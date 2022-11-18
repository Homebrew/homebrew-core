class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.19.3.tar.xz"
  sha256 "dae047f399c5a47f087db5d3d9d9e8f11ae4985d14c928d71da1aff801802d55"
  license "BSD-2-Clause"
  head "https://github.com/randombit/botan.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?Botan[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "a2ab8e2e8bc1f2f2b0d2c5c9a6e70db7dbf6d8da0f59d7877ae65d0f3e080dac"
    sha256 arm64_monterey: "f8e217c1f88a3eda865ba873cf7ecde4054a9d03736bc3dbd8e5a447c5ad3750"
    sha256 arm64_big_sur:  "7af675db93c0d3d31a3fc732640932bdefe5bb871359bfdfef6bf487e9910804"
    sha256 ventura:        "b29a58fa7e9b7663d5640fd4930e0beb28a14db52cb7e6657f6c087f85fc486c"
    sha256 monterey:       "6129e49f6502200987dc9f7e0439e1c0ef51a0fe806048ebd6ddce27744f095e"
    sha256 big_sur:        "580e1e95815e36d9a7faad7201b6f65f3938485bb6c9058c1369fdb37cfee08e"
    sha256 catalina:       "392dac3351b9e32ceaf9f7e8fa40e6fb5a87be7bb76894f469fd25a7e19ca95e"
    sha256 x86_64_linux:   "7c5b47bf0f430903a03e71cf065010af7095c30ce8a55421759130a1c11572ce"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

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

    system "python3.11", "configure.py", *args
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Homebrew"
    (testpath/"testout.txt").write shell_output("#{bin}/botan base64_enc test.txt")
    assert_match "Homebrew", shell_output("#{bin}/botan base64_dec testout.txt")
  end
end
