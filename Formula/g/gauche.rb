class Gauche < Formula
  desc "R7RS Scheme implementation, developed to be a handy script interpreter"
  homepage "https://practical-scheme.net/gauche/"
  url "https://github.com/shirok/Gauche/releases/download/release0_9_15/Gauche-0.9.15.tgz"
  sha256 "3643e27bc7c8822cfd6fb2892db185f658e8e364938bc2ccfcedb239e35af783"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^\D*?(\d+(?:[._]\d+)+(?:[._-]?p\d+)?)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("_", ".") }
    end
  end

  bottle do
    sha256 arm64_sequoia:  "34e7cab7687a3fad3c7a4e24cc869f71db411c4b9b83ca93daab9b3f205ae828"
    sha256 arm64_sonoma:   "090ea0130482168c2f2c8ba1bce87c9b3e2c6cb5066dd89d311848a8d5b9a742"
    sha256 arm64_ventura:  "1a6606f8577358fea7eae8a2de08c7f5d994796e7554578e57e17cc03cc350e2"
    sha256 arm64_monterey: "2b960106887fc6c0bb983e472fed0f740ed5f7f0ff6fd81fb8072645f247bfa0"
    sha256 sonoma:         "723aa7870618f0a7591472266d84817873b8f6956c3d68200bfa95b2cd62547d"
    sha256 ventura:        "2fb60084dd73329026216d0ee1177d4a62ff5bbb6e2466ed6a6fc53816513edc"
    sha256 monterey:       "2b079d1c270ec9ea36caed1f2762a88120f61326f2b81a67128aef54304d9295"
    sha256 arm64_linux:    "94f40a53316e570db2ded529c5cf1be6f4cfed7de7c2bb51085cd29604db80f6"
    sha256 x86_64_linux:   "bdff2646649040e73891540a312c8280bfed6a5427a8a5748b57fee8560c1c63"
  end

  depends_on "ca-certificates"
  depends_on "mbedtls"

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    system "./configure",
           *std_configure_args,
           "--enable-multibyte=utf-8",
           "--with-ca-bundle=#{HOMEBREW_PREFIX}/share/ca-certificates/cacert.pem"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/gosh -V")
    assert_match "(version \"#{version}\")", output
    assert_match "(gauche.net.tls mbedtls)", output
  end
end
