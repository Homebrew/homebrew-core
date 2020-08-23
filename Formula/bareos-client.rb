class BareosClient < Formula
  desc "Client for Bareos (Backup Archiving REcovery Open Sourced)"
  homepage "https://www.bareos.org/"
  url "https://github.com/bareos/bareos/archive/Release/19.2.8.tar.gz"
  sha256 "694ccf3ce5e84800335fda1d20bc681fcab77ab746f70c072b7c37b5b9f71a44"
  license "AGPL-3.0"

  bottle do
    sha256 "9d23bb8c20bc022d7426df495d12f79f49dc57c1b7cf0779c1be3d763e5e87fc" => :catalina
    sha256 "f75f72d5c4a2758e5ea68c9eeba4688e523db15aa5c0a4120fcb094199200036" => :mojave
    sha256 "a02db1b627c88aee9a740343533a99726c0e5b9f89168aa1b2ffad757ae59909" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "gettext"
  depends_on "openssl@1.1"
  depends_on "readline"

  conflicts_with "bacula-fd",
    because: "both install a `bconsole` executable"

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

  plist_options startup: true

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
