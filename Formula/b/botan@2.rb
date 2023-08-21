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
    sha256 arm64_ventura:  "db87e45ec9a5f29624c37869d7f85f194d882df98857cd5998b3cf6945c6a668"
    sha256 arm64_monterey: "264a52093b9e5766f7355a02d7edc225950cbf7934beedad55fba151993e9d10"
    sha256 arm64_big_sur:  "04571b6d81d868fd8c2ace48c8880ea2b8a706c1497783df4a191179aaf08136"
    sha256 ventura:        "671661b12c35740b7dfdd3c1fd5685e0c395169c6004dce01f36dd6810b17708"
    sha256 monterey:       "f89027a21ad80555283428ebab8849168e643bdf22c7df8155024b5a128d515e"
    sha256 big_sur:        "5a55196bc320904ac4195f49211ee897776efa44c677e85a9e8f30e85e54eec0"
    sha256 x86_64_linux:   "b001bf81ca13d97035ee74a7192c41eb68cd573110bacc56f1ed58686a23bda4"
  end

  keg_only :versioned_formula

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
