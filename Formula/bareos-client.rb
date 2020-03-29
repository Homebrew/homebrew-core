class BareosClient < Formula
  desc "Client for Bareos (Backup Archiving REcovery Open Sourced)"
  homepage "https://www.bareos.org/"
  url "https://github.com/bareos/bareos/archive/Release/19.2.6.tar.gz"
  sha256 "688505f8bc45b919dfd1c8bdcd448b4bdbe1ea2d1755358a94d702e9aff8482b"

  bottle do
    sha256 "afd57cdc34b88e67673ca416ca95bd10490a51ed4158ac503e41d42130eb4964" => :catalina
    sha256 "da9c6752912285c42f35ef5cc75fc51cf51326dd80fe8eafb454fda5a522e585" => :mojave
    sha256 "a3cc09799454c9387eef89150a48d6dabfa6f095f2b72b59094f0e5a0a4da4f1" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "gettext"
  depends_on "openssl@1.1"
  depends_on "readline"

  conflicts_with "bacula-fd",
    :because => "Both install a `bconsole` executable."

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-Dworkingdir=#{var}/lib/bareos",
                            "-Darchivedir=#{var}/bareos",
                            "-Dconfdir=#{etc}/bareos",
                            "-Dconfigtemplatedir=#{lib}/bareos/defaultconfigs",
                            "-Dscriptdir=#{lib}/bareos/scripts",
                            "-Dplugindir=#{lib}/bareos/plugins",
                            "-Dfd-password=XXX_REPLACE_WITH_CLIENT_PASSWORD_XXX",
                            "-Dmon-fd-password=XXX_REPLACE_WITH_CLIENT_MONITOR_PASSWORD_XXX",
                            "-Dbasename=XXX_REPLACE_WITH_LOCAL_HOSTNAME_XXX",
                            "-Dhostname=XXX_REPLACE_WITH_LOCAL_HOSTNAME_XXX",
                            "-Dclient-only=ON"
      system "make"
      system "make", "install"
    end
  end

  def post_install
    # If no configuration files are present,
    # deploy them (copy them and replace variables).
    unless (etc/"bareos/bareos-fd.d").exist?
      system lib/"bareos/scripts/bareos-config", "deploy_config",
             lib/"bareos/defaultconfigs", etc/"bareos", "bareos-fd"
      system lib/"bareos/scripts/bareos-config", "deploy_config",
             lib/"bareos/defaultconfigs", etc/"bareos", "bconsole"
    end
  end

  plist_options :startup => true

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_sbin}/bareos-fd</string>
            <string>-f</string>
          </array>
          <key>StandardOutPath</key>
          <string>#{var}/run/bareos-fd.log</string>
          <key>StandardErrorPath</key>
          <string>#{var}/run/bareos.log</string>
          <key>RunAtLoad</key>
          <true/>
        </dict>
      </plist>
    EOS
  end

  test do
    # Check if bareos-fd starts at all.
    assert_match version.to_s, shell_output("#{sbin}/bareos-fd -? 2>&1", 1)
    # Check if the configuration is valid.
    system sbin/"bareos-fd", "-t"
  end
end
