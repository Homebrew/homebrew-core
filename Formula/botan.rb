class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.18.1.tar.xz"
  sha256 "f8c7b46222a857168a754a5cc329bb780504122b270018dda5304c98db28ae29"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/randombit/botan.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "7cf8ee231da3bf5e0714fece84c806b9f1818084b045e5b7b4a28de522cf19eb"
    sha256 big_sur:       "e96dece29ae8738b7e97252acccad52006c0fc14bd59da5f72f8bfc09849a8f6"
    sha256 catalina:      "7c9aae0f752f8827c9d68ef503be55164efee19a101f0bd8e2000bee28859863"
    sha256 mojave:        "f5fcd260558eb589c046e43366e1dd243465c12cc40f09048668f44f937f37d6"
    sha256 x86_64_linux:  "7c1c471ea99435496326959270c2e25ca6b7058eef776a7f690a87062687536f"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10"
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
    ]

    system "python3", "configure.py", *args
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Homebrew"
    (testpath/"testout.txt").write shell_output("#{bin}/botan base64_enc test.txt")
    assert_match "Homebrew", shell_output("#{bin}/botan base64_dec testout.txt")
  end
end
