class Freediameter < Formula
  desc "Open source Diameter (Authentication) protocol implementation"
  homepage "http://www.freediameter.net"
  url "http://www.freediameter.net/hg/freeDiameter/archive/1.4.0.tar.gz"
  sha256 "7a537401bd110c606594b7c6be71b993f0ccc73ae151ad68040979286ba4e50e"
  head "http://www.freediameter.net/hg/freeDiameter", using: :hg

  bottle do
    cellar :any
    sha256 "f63eb43c09115ecc506fb8a3f0cccc4293ee21d8b408a745508cb8a5dadb935f" => :catalina
    sha256 "f41db0f291fcbbafecd7325c440dbaa2f61df4a250d9a18b216606130df020bc" => :mojave
    sha256 "66df7c67d2a5f4c18a907df28d115004e1ad016e60af64f2e138356e90458bca" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libidn"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DDEFAULT_CONF_PATH=#{etc}",
                      "-DDISABLE_SCTP=ON"
      system "make"
      system "make", "install"
    end

    doc.install Dir["doc/*"]
    pkgshare.install "contrib"
  end

  def post_install
    return if File.exist?(etc/"freeDiameter.conf")

    cp doc/"freediameter.conf.sample", etc/"freeDiameter.conf"
  end

  def caveats
    <<~EOS
      To configure freeDiameter, edit #{etc}/freeDiameter.conf to taste.

      Sample configuration files can be found in #{doc}.

      For more information about freeDiameter configuration options, read:
        http://www.freediameter.net/trac/wiki/Configuration

      Other potentially useful files can be found in #{opt_pkgshare}/contrib.
    EOS
  end

  plist_options startup: true

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/freeDiameterd</string>
          </array>
          <key>KeepAlive</key>
          <dict>
            <key>NetworkState</key>
            <true/>
          </dict>
        </dict>
      </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/freeDiameterd --version")
  end
end
