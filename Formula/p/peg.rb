class Peg < Formula
  desc "Program to perform pattern matching on text"
  homepage "https://www.piumarta.com/software/peg/"
  url "https://www.piumarta.com/software/peg/peg-0.1.19.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/p/peg/peg_0.1.19.orig.tar.gz"
  sha256 "0013dd83a6739778445a64bced3d74b9f50c07553f86ea43333ae5fab5c2bbb4"
  license "MIT"

  # The homepage links to development tarballs using the stable version format
  # (with nothing in the file name to distinguish stable/development), so we
  # check the "current stable version is 1.2.3" text.
  livecheck do
    url :homepage
    regex(/current\s+stable\s+version\s+is\s+v?(\d+(?:\.\d+)+)/im)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "69199b8b5ca9791da1895d31d558d1205468f97741268abb2bb7944320cf050b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f2404175aa4fe06bfa03b4cd11cd1aa8ae657e85353062c11c73c553544a032e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ed0bb60eaf375b862b8c0b33deb2cdf50ac0926ebcdf0570f06f1a28e5ffa00"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebbeb402eb35f2b4cf3c7d6ea4ad2a69aa5e820ab79a82009ed829a56ea6945a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b03363610a4e6408dddc5c5b5aa6db243cb48def84e14cd910dc40e3ecbf5a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "dde90ca660bdf7d086e1552195a2f6523550c77ce846a1ce6b72381046594861"
    sha256 cellar: :any_skip_relocation, ventura:        "c5093be933ee74c35e8eef5805da9db1cc5f4f5312482039dec5abdc39a9da75"
    sha256 cellar: :any_skip_relocation, monterey:       "e0189aa87097be5b4d6bdb026201d3920fc085df5aa33b250cd7c3c0bc0228b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d4cf66155b03b7df188f33b1df5bf9b7f529a3544416292795414a6fb613b741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "344b71933baafa8d0d1e9c685b67f73726f5f6372953346ae8460edab2acc015"
  end

  def install
    system "make", "all"
    bin.install %w[peg leg]
    man1.install Utils::Gzip.compress("src/peg.1")
  end

  test do
    (testpath/"username.peg").write <<~EOS
      start <- "username"
    EOS

    system bin/"peg", "-o", "username.c", "username.peg"

    assert_match 'yymatchString(yy, "username")', File.read("username.c")
  end
end
