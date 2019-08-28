class BareosClient < Formula
  desc "Client for Bareos (Backup Archiving REcovery Open Sourced)"
  homepage "https://www.bareos.org/"
  url "https://github.com/bareos/bareos/archive/Release/17.2.7.tar.gz"
  sha256 "99a5f907e3422532c783ee254dcf5c737d2b1b53522c00924d3e1009289d2fd2"
  revision 1

  bottle do
    sha256 "d597282300909ac572b5047abc5a1840a5cdbac7a0dd3bc57e97cb5ab2e29c6d" => :mojave
    sha256 "b8b3ba172f69be5c28656466d8225e4d4a02175e419666c205d98a6440323c28" => :high_sierra
    sha256 "f4cb5ceaa5c0795aca38e6ced82cff2bee7c3ccfd6b83e7b49f161818e5c0e28" => :sierra
  end

  depends_on "openssl@1.1"
  depends_on "readline"

  conflicts_with "bacula-fd",
    :because => "Both install a `bconsole` executable."

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-working-dir=#{var}/lib/bareos",
                          "--with-archivedir=#{var}/bareos",
                          "--with-confdir=#{etc}/bareos",
                          "--with-configtemplatedir=#{lib}/bareos/defaultconfigs",
                          "--with-scriptdir=#{lib}/bareos/scripts",
                          "--with-plugindir=#{lib}/bareos/plugins",
                          "--with-fd-password=XXX_REPLACE_WITH_CLIENT_PASSWORD_XXX",
                          "--with-mon-fd-password=XXX_REPLACE_WITH_CLIENT_MONITOR_PASSWORD_XXX",
                          "--with-basename=XXX_REPLACE_WITH_LOCAL_HOSTNAME_XXX",
                          "--with-hostname=XXX_REPLACE_WITH_LOCAL_HOSTNAME_XXX",
                          "--with-python",
                          "--enable-client-only"

    # The file platforms/osx/Makefile is intended for other environment (not homebrew)
    # and would break the build process.
    # Therefore it is removed until this has been fixed upstream,
    # see https://bugs.bareos.org/view.php?id=900
    rm "platforms/osx/Makefile"

    system "make", "install"
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
