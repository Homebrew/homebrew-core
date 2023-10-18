class BotanAT2 < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.19.3.tar.xz"
  sha256 "dae047f399c5a47f087db5d3d9d9e8f11ae4985d14c928d71da1aff801802d55"
  license "BSD-2-Clause"
  head "https://github.com/randombit/botan.git", branch: "release-2"

  livecheck do
    url :homepage
    regex(/href=.*?Botan[._-]v?(2(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "91d7610568988bac4aa345bfd033a80e466e00028ef4286f4cd421aeb083ecca"
    sha256 arm64_ventura:  "c5ddedf9d32ad09db9049ce80031452c5c93755898798a80dfa285d8b9911509"
    sha256 arm64_monterey: "d405327b3d35771f6df79796cb909c45d29e1afb65ed3b953413e4794f98258e"
    sha256 sonoma:         "4b295a8058f7dfa5006818b9db7197ece733096aefa395d2c1e8af725fdcc4f2"
    sha256 ventura:        "2a9a968ad01036447af447f8054cf720b4ecb2b5a0cf3c98b790b4bc8b29c28e"
    sha256 monterey:       "598e69c6e5774133e25cc2dd3d247655a68024a1f03cacf219e85e11c27376c5"
    sha256 x86_64_linux:   "30b13542e19646b0f31fa5fafb9050172c5b232341069bbec8798c3703fcca8a"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "python@3.12"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  def python3
    which("python3.12")
  end

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --docdir=share/doc
      --with-zlib
      --with-bzip2
      --with-sqlite3
    ]

    system python3, "configure.py", *args
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Homebrew"
    (testpath/"testout.txt").write shell_output("#{bin}/botan base64_enc test.txt")
    assert_match "Homebrew", shell_output("#{bin}/botan base64_dec testout.txt")
  end
end
