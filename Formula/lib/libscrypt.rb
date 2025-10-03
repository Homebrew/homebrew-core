class Libscrypt < Formula
  desc "Library for scrypt"
  homepage "https://github.com/technion/libscrypt"
  url "https://github.com/technion/libscrypt/archive/refs/tags/v1.22.tar.gz"
  sha256 "a2d30ea16e6d288772791de68be56153965fe4fd4bcd787777618b8048708936"
  license "BSD-2-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "1282d862a6fe6bda7018c46eb83f037202246c3f8ba35fcddae779effc79b266"
    sha256 cellar: :any,                 arm64_sequoia:  "7a251107f146f88d993fa4fe542c8fbd92d9123904359f91ac5f44aedbb90344"
    sha256 cellar: :any,                 arm64_sonoma:   "78e0f597bcaeb181e0845127db7303d52a4ae34df6f6c61c2759006a45f716ab"
    sha256 cellar: :any,                 arm64_ventura:  "27b5cd1ef28e190b9f73c5c617ee652b331eab24cb25bd3129335ad1c0299f76"
    sha256 cellar: :any,                 arm64_monterey: "df9e62c90fb8530ad765f2128a892ba91904901167bb5dcb7f0e1a199b43f59f"
    sha256 cellar: :any,                 arm64_big_sur:  "6b39d428937056b1a25080c87d9af446ae1397f824d362ca6a791e683a997ed2"
    sha256 cellar: :any,                 sonoma:         "82c9ff58481a5c6a44d7f85b083f614004371fc2572f9a8c8c07de4bee06cf0b"
    sha256 cellar: :any,                 ventura:        "ce5a3c6a6e0f0e100eb6b9d515389a371ac2bdc3f18b4aeb7f0909ce8b3b4b99"
    sha256 cellar: :any,                 monterey:       "d8e0b6fe9b5e2f14fc281fa859fb3339eb98610863cb0b39652f5cb6522205ad"
    sha256 cellar: :any,                 big_sur:        "836c0ae075b9e3b580eea4d3c1b554f861166f74657303103bb0415c34650fb8"
    sha256 cellar: :any,                 catalina:       "d53d94bee86fdb65f96abdb62f07f5f2867773fd0719562a21ad320465ebd686"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2a407f084d02366dfdbc3dd3801036bee1cf4a7c33f51337ce0418761532939c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62ae9fdeea1cbe282839585250e2adacea715d313975bf6eb863a579aa669a21"
  end

  # Backport fix for aliasing violations
  patch do
    url "https://github.com/technion/libscrypt/commit/7b574b9c517a3d1f9bd0e265a5f287155293cb85.patch?full_index=1"
    sha256 "5f3b4eaef826191318b57d1c0fe2889d76d18bf17746af2ba5417ccf27ec039f"
  end

  def install
    args = ["PREFIX=#{prefix}"]
    install_target = "install"

    if OS.mac?
      args += %w[CFLAGS_EXTRA=-fstack-protector LDFLAGS= LDFLAGS_EXTRA=]
      install_target << "-osx"
    end

    system "make", "check", *args
    system "make", install_target, *args
    system "make", "install-static", *args

    return if OS.mac?

    prefix.install "libscrypt.version"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libscrypt.h>
      int main(void) {
        char buf[SCRYPT_MCF_LEN];
        libscrypt_hash(buf, "Hello, Homebrew!", SCRYPT_N, SCRYPT_r, SCRYPT_p);
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lscrypt", "-o", "test"
    system "./test"
  end
end
