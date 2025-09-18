class Cloog < Formula
  desc "Generate code for scanning Z-polyhedra"
  homepage "https://github.com/periscop/cloog"
  url "https://github.com/periscop/cloog/releases/download/cloog-0.21.1/cloog-0.21.1.tar.gz"
  sha256 "d370cf9990d2be24bfb24750e355bac26110051248cabf2add61f9b3867fb1d7"
  license "LGPL-2.1-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "398e809f0432ab4350d43531f5918d4d2610c63a69e3ff3d7843275c8eb332bd"
    sha256 cellar: :any,                 arm64_sequoia:  "a094bf71fc868a36e66ae12b4a3de5ad0c887f9f92278a473722273bad35fd64"
    sha256 cellar: :any,                 arm64_sonoma:   "ead03f190330ee52bead39f8d29fdb67667882b5acecaa490f6d63c2bc750cac"
    sha256 cellar: :any,                 arm64_ventura:  "cead91fed1a94c7121eb28dbd53060c3bf70a83c62a0546e50d2ec486e1e1e63"
    sha256 cellar: :any,                 arm64_monterey: "9d8c88f5f09bcc01984b15f0ba5d2fe143ee4e129f7dafce268cb36831f33480"
    sha256 cellar: :any,                 arm64_big_sur:  "c0c6fe61fc3cab274494d0afc7c1d3391b58890544efd5f43e4ab13c3c7fccfe"
    sha256 cellar: :any,                 sonoma:         "df4fcfc84b3e7d63f3443caca892be8d75bcd7d59f42ec2353d8358f646253db"
    sha256 cellar: :any,                 ventura:        "d46074ebafa3ac16eedd35381930c80446da0db12109746fc39ad316dc9f98a2"
    sha256 cellar: :any,                 monterey:       "3a6c23a37dcb685ec5ecdd08921dcad09c121d3e0763c0df609e6a9c85fcd964"
    sha256 cellar: :any,                 big_sur:        "9e572d9cca3d5da40666ea38027e38e4189f8c8471d4fe12376828f234b12721"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "63b976028eeb44aef31fa6c5643249a4ce8881125d7567ffd710f0743cbb71d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0f9fc5de0ae2ddc6bc734ae97b67cf0173ba90da90db87f5402d36c3bcc0ef6"
  end

  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "isl"

  def install
    # Avoid doc build.
    ENV["ac_cv_prog_TEXI2DVI"] = ""

    system "./configure", "--disable-silent-rules",
                          "--with-gmp=system",
                          "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}",
                          "--with-isl=system",
                          "--with-isl-prefix=#{Formula["isl"].opt_prefix}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cloog").write <<~EOS
      c

      0 2
      0

      1

      1
      0 2
      0 0 0
      0

      0
    EOS

    assert_match %r{Generated from #{testpath}/test.cloog by CLooG},
                 shell_output("#{bin}/cloog #{testpath}/test.cloog")
  end
end
