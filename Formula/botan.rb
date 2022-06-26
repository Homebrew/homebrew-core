class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.19.2.tar.xz"
  sha256 "3af5f17615c6b5cd8b832d269fb6cb4d54ec64f9eb09ddbf1add5093941b4d75"
  license "BSD-2-Clause"
  head "https://github.com/randombit/botan.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?Botan[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "d915afe43b2437fe42e94a3392a5855b258b6ed6b5511ead2a0fbf9886a0461b"
    sha256 arm64_big_sur:  "87689319c0f9a4a1c007c3609f780490f9f7120652220a63828e0316f6d14cee"
    sha256 monterey:       "e173868c663e129ce4af972cd7efc567f25e623c6e9ee956b8230719b74a943c"
    sha256 big_sur:        "1f25905970becbcc4b508dfcf5c48a2e018692ed3267f08c5061133b4e3ac60c"
    sha256 catalina:       "bb925ad7521c9f2d966b452de0763517cf2b1e65700aae1c9cbcc6a01334e9f1"
    sha256 x86_64_linux:   "3c27ab2df31d5c3e583bccbfb45767515104826e7c031ca996e6114a2cdbfa99"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

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
