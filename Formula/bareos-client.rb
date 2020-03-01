class BareosClient < Formula
  desc "Client for Bareos (Backup Archiving REcovery Open Sourced)"
  homepage "https://www.bareos.org/"
  url "https://github.com/bareos/bareos/archive/Release/19.2.6.tar.gz"
  sha256 "688505f8bc45b919dfd1c8bdcd448b4bdbe1ea2d1755358a94d702e9aff8482b"

  bottle do
    sha256 "7d69e52f214e7e5b8cf30e28ee49344165aea78837a4549b7699f01010b69dce" => :catalina
    sha256 "d597282300909ac572b5047abc5a1840a5cdbac7a0dd3bc57e97cb5ab2e29c6d" => :mojave
    sha256 "b8b3ba172f69be5c28656466d8225e4d4a02175e419666c205d98a6440323c28" => :high_sierra
    sha256 "f4cb5ceaa5c0795aca38e6ced82cff2bee7c3ccfd6b83e7b49f161818e5c0e28" => :sierra
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

  def plist; <<~EOS
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
