class BotanAT2 < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.19.5.tar.xz"
  sha256 "dfeea0e0a6f26d6724c4af01da9a7b88487adb2d81ba7c72fcaf52db522c9ad4"
  license "BSD-2-Clause"
  head "https://github.com/randombit/botan.git", branch: "release-2"

  livecheck do
    url :homepage
    regex(/href=.*?Botan[._-]v?(2(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "26123f333ae9d3b9370ac9c25537f01905e7bd6f1d4d87efd186be3128dbf78f"
    sha256 arm64_ventura:  "a3827282841699000756d03c5d5e53c5224e67f340c7e7c5fc43d93e19a4e370"
    sha256 arm64_monterey: "291b91e6418c3be4e290f42f72bf690f05867ab19cb6d7b5a2af031a65ccf960"
    sha256 sonoma:         "354bea166821d3957ad270afe95798cb159e1117b45d55664f2a67c51b931a1b"
    sha256 ventura:        "2eb567dfa4a898b0d99d06c6219d5098f74ba77c72258f7b580d0facdb6d769c"
    sha256 monterey:       "f5d51f622c5146a9e830274f3a0a94f6570029824b938d91ebed895fc6d93c88"
    sha256 x86_64_linux:   "eca2b5787826800519a4b0d51e28818b93cc9f8c2136af9b70c9ebb2dd3a7952"
  end

  keg_only :versioned_formula

  # Botan2 is currently scheduled to reach end of life at the end of 2024
  # Ref: https://botan.randombit.net/#releases
  deprecate! date: "2024-12-31", because: :unsupported

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
