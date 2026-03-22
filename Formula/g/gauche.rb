class Gauche < Formula
  desc "R7RS Scheme implementation, developed to be a handy script interpreter"
  homepage "https://practical-scheme.net/gauche/"
  url "https://github.com/shirok/Gauche/releases/download/release0_9_15/Gauche-0.9.15.tgz"
  sha256 "3643e27bc7c8822cfd6fb2892db185f658e8e364938bc2ccfcedb239e35af783"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^\D*?(\d+(?:[._]\d+)+(?:[._-]?p\d+)?)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("_", ".") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "4dcc399b09f0db638cb74c51b46a1d289f7d9eb7602e1632f409af0d780d6b70"
    sha256 arm64_sequoia: "4b312853feb31d6e0c53f679e95365ed3990ae356e956d37c4b2f2ee89ea6ac6"
    sha256 arm64_sonoma:  "66e48914a2fed1e6561d51ebd211968a501dabb9915744995afe9fc437b3dd1b"
    sha256 sonoma:        "53b8b035250f0814c8a2cc90c59e05ca51ef82116a487fc76ceece4cfad07e48"
    sha256 arm64_linux:   "1b93c768dbd692d811173b3c6b9773165d88060cfca88764493b05f0e9ba05a2"
    sha256 x86_64_linux:  "ad6815598d031b43b878c75511c43cee7e1d18bafc3cb1e59781c0fcdd5c560d"
  end

  depends_on "ca-certificates"
  depends_on "mbedtls@3"

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      --enable-multibyte=utf-8
      --with-ca-bundle=#{HOMEBREW_PREFIX}/share/ca-certificates/cacert.pem
    ]
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/gosh -V")
    assert_match "(version \"#{version}\")", output
    assert_match "(gauche.net.tls mbedtls)", output
  end
end
