class Freediameter < Formula
  desc "Open source Diameter (Authentication) protocol implementation"
  homepage "http://www.freediameter.net"
  url "http://www.freediameter.net/hg/freeDiameter/archive/1.5.0.tar.gz"
  sha256 "2500f75b70d428ea75dd25eedcdddf8fb6a8ea809b02c82bf5e35fe206cbbcbc"
  license "BSD-3-Clause"
  head "http://www.freediameter.net/hg/freeDiameter", using: :hg

  bottle do
    cellar :any
    sha256 "2c99cc840e0daebf52793d55e91ec616416c7fc7c4f4a8c332c6fe8c52fd181d" => :big_sur
    sha256 "a2fd2271af79fd86ec7162e0af3adbaf611f280563a84dc2a98af96b7b3a3a4d" => :arm64_big_sur
    sha256 "92933b4a5076f85098b784f47f3943065444b9dda243c6165d38aaffb9122b68" => :catalina
    sha256 "3d5aa2577193d90113f4deadd81c6db0b40384a4cf3cca096e6edeb76ee734e3" => :mojave
    sha256 "a242566b7096b737a094ebe7c792fe306ab6f06f28cded3b5c6660962b812610" => :high_sierra
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
