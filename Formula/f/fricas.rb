class Fricas < Formula
  desc "Advanced computer algebra system"
  homepage "https://fricas.github.io"
  url "https://github.com/fricas/fricas/releases/download/1.4.0/fricas-1.4.0-full.tar.bz2"
  sha256 "e113c721aaba673226d0806076a12ec82c07562c2954479443047d4264172514"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e456dde0e8d3c3499d13ad15f6c9d07e609744d1e3fea29c48018ca609939e06"
    sha256 cellar: :any, arm64_tahoe:       "0640dae52ae26122b806c5216208d84f6ec8d999c40a7e45b519f0ad7a004b7e"
    sha256 cellar: :any, arm64_sequoia:     "00569be634dff84d65f0887e8a439af7b8ed0a9bd47929c774c22ecb013f6185"
    sha256 cellar: :any, arm64_linux:       "92ab0b0f852d615a56d657a4f7a2524602e7afd1aa575840cb38211ddb0192ee"
    sha256 cellar: :any, x86_64_linux:      "a4b33fc89353ac231d2868efd6e8943867c04f9e3850e0fc7e26cffa71044747"
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
