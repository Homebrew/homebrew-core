class Fricas < Formula
  desc "Advanced computer algebra system"
  homepage "https://fricas.github.io"
  url "https://github.com/fricas/fricas/archive/refs/tags/1.3.13.tar.gz"
  sha256 "7ae03c0f566c4b2bbbd6da1b02965e2a5492b1b8e4f8f2f1d1329c72d44e42a2"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/fricas/fricas.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7b856e01080257bf1418432b9633189ca4ed781644524e7ef0b1cdba4ef09cba"
    sha256 cellar: :any,                 arm64_sequoia: "beca5845c91aec92b2844507a0e1c1a4e64cb28f713640d6b3652ecae07f87ad"
    sha256 cellar: :any,                 arm64_sonoma:  "9cc86a56336782739c1bd28d9848170ae62db1aa37456a5d6e2bdf8d14d8994c"
    sha256 cellar: :any,                 sonoma:        "651b30b071db7d69a3f1d8cef34c85bbd37457ace6fa0b62e05e93506bd6b609"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b9e34d998169fd9e1d837294bda4618bea09f089cba87981d239b6fe1097176"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39384b0a803129743c8cb647dd8a5dfc8826074e418bfc20bd009e3e4a828f70"
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
