class Gauche < Formula
  desc "R7RS Scheme implementation, developed to be a handy script interpreter"
  homepage "https://practical-scheme.net/gauche/"
  url "https://github.com/shirok/Gauche/releases/download/release0_9_12/Gauche-0.9.12.tgz"
  sha256 "b4ae64921b07a96661695ebd5aac0dec813d1a68e546a61609113d7843f5b617"
  license "BSD-3-Clause"
  revision 3

  livecheck do
    url :stable
    regex(/^\D*?(\d+(?:[._]\d+)+(?:[._-]?p\d+)?)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("_", ".") }
    end
  end

  bottle do
    sha256 arm64_ventura:  "a405af2d4cd3ac595928e1713096afa3c19fc9d3d565a5821463b8f0146efbc5"
    sha256 arm64_monterey: "459940972d99810f83d2f6432f76d0ea929e62f42540b08e5b0e804063e821ab"
    sha256 arm64_big_sur:  "3f1ae018358693ebc71fdc297292fef73b64281d7baed0cd2b7a422494235196"
    sha256 ventura:        "93b04221e3e6956136b41dfa5d1ae0f4dc4cfe5792fad57620e67bb679409b3c"
    sha256 monterey:       "f1ebc15552fbfa676c5d582bdbe2677057b38b06749f1c1170464e6f72e44eb2"
    sha256 big_sur:        "2350bfff9a4903b6f6c467ba31a4256895d37f9833f17e7f3197b1f9ce36444c"
    sha256 x86_64_linux:   "5a93f25ad4b33928436877885191f48a00aa3b580214f42dd8a329c9686e6d05"
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
