class BareosClient < Formula
  desc "Client for Bareos (Backup Archiving REcovery Open Sourced)"
  homepage "https://www.bareos.org/"
  url "https://github.com/bareos/bareos/archive/Release/19.2.7.tar.gz"
  sha256 "283c1fa9cb6a96b1f09b402cd507ecd8bf798458bafcbfad867da08d33d12653"

  bottle do
    sha256 "c398b94b0cd74715b26a53369d6b8fdabe6c4c9cf876c27bbf3394801d2d1fb6" => :catalina
    sha256 "91276e1c2e1e35c2ee7c00b8c7b4b56647c15290e4ae402ca42557a675cc14aa" => :mojave
    sha256 "95c59dc77b15fed9cc99aa41328d745192b7b03a3b77f1d343f81cd724ecd65a" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "gettext"
  depends_on "openssl@1.1"
  depends_on "readline"

  conflicts_with "bacula-fd",
    :because => "both install a `bconsole` executable"

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
