class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.16.0.tar.xz"
  sha256 "92ed6ebc918d86bd1b04221ca518af4cf29cc326c4760740bd2d22e61cea2628"
  license "BSD-2-Clause"
  head "https://github.com/randombit/botan.git"

  bottle do
    sha256 "9fa7cc2c1782d8fdaac1b6bb4bb5cf3d39817cd51de91a061da241599165203a" => :catalina
    sha256 "1994726d7e74837c73da3be3b897e621d52c6aa1d83b3e495b8ff7897b878691" => :mojave
    sha256 "e57441b37a2f1ae109ecebd218a3a1aa1c1dc99e021db6f50fa9eea226302045" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.8"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --docdir=share/doc
      --cc=#{ENV.compiler}
      --os=darwin
      --with-zlib
      --with-bzip2
      --with-sqlite3
      --with-python-versions=3.8
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
