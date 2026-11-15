class Fricas < Formula
  desc "Advanced computer algebra system"
  homepage "https://fricas.github.io"
  url "https://github.com/fricas/fricas/releases/download/1.4.0/fricas-1.4.0-full.tar.bz2"
  sha256 "e113c721aaba673226d0806076a12ec82c07562c2954479443047d4264172514"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "19e8489980440724251e2239cc19851f6704ba045da5d1314ffd8205443458e0"
    sha256 cellar: :any, arm64_tahoe:       "84fc55f7ed80bc4d3f329518891a3cd7e11a275f02377e1743f10a22672889d1"
    sha256 cellar: :any, arm64_sequoia:     "9d00fe01185d295f387e5ef8b6f59253b684957ecd4cb496f2cadfc1537a5460"
    sha256 cellar: :any, arm64_linux:       "c57177f9de1c7722979869f56839708163a689f62a81abdd5e6f2391c4de8b94"
    sha256 cellar: :any, x86_64_linux:      "de8d79d1599836cf1a0d1364cbddb4c39ca93a0377ca9dca55d0b4bc50badc76"
  end

  depends_on "gmp"
  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxau"
  depends_on "libxdmcp"
  depends_on "libxpm"
  depends_on "libxt"
  depends_on "sbcl"
  depends_on "zstd"

  def install
    args = %w[
      --with-lisp=sbcl
      --enable-lisp-core
      --enable-gmp
    ]

    mkdir "build" do
      system "../configure", *std_configure_args, *args
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match %r{ \(/ \(pi\) 2\)\n},
      pipe_output("#{bin}/fricas -nosman", "integrate(sqrt(1-x^2),x=-1..1)::InputForm")
  end
end
