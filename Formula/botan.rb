class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.18.0.tar.xz"
  sha256 "cc64852e1e0c5bb30ecd052e4a12d5136125a8ce5c3be2efb6fb061c8677e327"
  license "BSD-2-Clause"
  head "https://github.com/randombit/botan.git"

  bottle do
    sha256 arm64_big_sur: "107ac4cae8611953a670a141d2719bdca508b54c83119397d2cbd4dc649c35d9"
    sha256 big_sur:       "3d8536823d45cec56da28939e54b4f1e4d33fd84e136d80d9f6c7067bf46a81c"
    sha256 catalina:      "68ae9bc8f5953f106fe248f7b0a209add68429275eac66d41b6ac15234433a0b"
    sha256 mojave:        "496c983f8ec163f1da762b62e4ebe7f21b1fc4186eddf7b6fd2adaf9eb6e9db8"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --docdir=share/doc
      --with-zlib
      --with-bzip2
      --with-sqlite3
      --with-python-versions=3.9
    ]

    system "./configure.py", *args
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Homebrew"
    (testpath/"testout.txt").write shell_output("#{bin}/botan base64_enc test.txt")
    assert_match "Homebrew", shell_output("#{bin}/botan base64_dec testout.txt")
  end
end
