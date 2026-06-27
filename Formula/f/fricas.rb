class Fricas < Formula
  desc "Advanced computer algebra system"
  homepage "https://fricas.github.io"
  url "https://github.com/fricas/fricas/archive/refs/tags/1.3.13.tar.gz"
  sha256 "7ae03c0f566c4b2bbbd6da1b02965e2a5492b1b8e4f8f2f1d1329c72d44e42a2"
  license "BSD-3-Clause"
  revision 4
  head "https://github.com/fricas/fricas.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0629eaad116aba12e5f30e19fca8ae9556e7e7042a4fb621df7fcf6aa2c8aebc"
    sha256 cellar: :any, arm64_sequoia: "236ac0b7b6d01f57f52bb908fcbaaa2ac471ff5dac9f096bc7bde5ba38793189"
    sha256 cellar: :any, arm64_sonoma:  "f330526f154535e395c683e008f8fc26cd9705f49ca6842af81cff2ee2271150"
    sha256 cellar: :any, sonoma:        "d0e9dc9aac9426b06b69537e019b62d2e45ba96ff3414613b4f653fe1c3ee5a8"
    sha256 cellar: :any, arm64_linux:   "143b16b3ad697545d4fa52815ec74db47aa6683a9af44f51f15b1d07a33f574d"
    sha256 cellar: :any, x86_64_linux:  "bef1a54566053c50103638eff23395e51f9e5c30384d2e72875a887df409c6f4"
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
    args = [
      "--with-lisp=sbcl",
      "--enable-lisp-core",
      "--enable-gmp",
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
