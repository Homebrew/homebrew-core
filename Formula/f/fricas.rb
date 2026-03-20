class Fricas < Formula
  desc "Advanced computer algebra system"
  homepage "https://fricas.github.io"
  url "https://github.com/fricas/fricas/archive/refs/tags/1.3.13.tar.gz"
  sha256 "7ae03c0f566c4b2bbbd6da1b02965e2a5492b1b8e4f8f2f1d1329c72d44e42a2"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/fricas/fricas.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cbd929073991809c6208d9050cba112b918316a62fce76b43818ba17738f06f3"
    sha256 cellar: :any,                 arm64_sequoia: "a29be8351e2e7cb37d4fa2e02fc33b31fce4d673d7f97f2384d776d8ad19a315"
    sha256 cellar: :any,                 arm64_sonoma:  "f7a3a288862576e2a3f7bd930baa15ed95bb00af73fae20c1fe98bfc8df798b4"
    sha256 cellar: :any,                 sonoma:        "270b1aef7093002c842f5993b3f061db40e8bcbb0b5761e51cce47e567983655"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d71cad8f8e90f19b5771deecbb349b75af269ea1f9f4b44f936a2c7e1fdcd8f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79a337ca5a1818af986c3e54dfe1c904bdaacc9aafccdd4f1844ccf36946aa57"
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
