class Fricas < Formula
  desc "Advanced computer algebra system"
  homepage "https://fricas.github.io"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/fricas/fricas.git", branch: "master"

  stable do
    url "https://github.com/fricas/fricas/archive/refs/tags/1.3.12.tar.gz"
    sha256 "f201cf62e3c971e8bafbc64349210fbdc8887fd1af07f09bdcb0190ed5880a90"

    # Build fricas as a SBCL core file instead of standalone executable.
    # Avoid patchelf issue on Linux and codesign issue on macOS.
    patch do
      url "https://github.com/fricas/fricas/commit/4d7624b86b1f4bfff799724f878cf3933459507d.patch?full_index=1"
      sha256 "dbfbd13da8ca3eabe73c58b716dde91e8a81975ce9cafc626bd96ae6ab893409"
    end
    patch do
      url "https://github.com/fricas/fricas/commit/03e4e83288ea46bb97f23c05816a9521f14734b7.patch?full_index=1"
      sha256 "3b9dca32f6e7502fea08fb1a139d2929c89fe7f908ef73879456cbdd1f4f0421"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "14cd63e267c22e3b4b137ee90c9cc43b5f8f94e9db99634470b9e2824ed5ac5b"
    sha256 cellar: :any,                 arm64_sequoia: "f682a69dc065379f6d23e3df54efa768d0ed1c98504d5ad2979d9b0daa34f88b"
    sha256 cellar: :any,                 arm64_sonoma:  "a72eb597042e63a3c24cf4685dabdd6f44e048bcce481288fba1ca36771e3163"
    sha256 cellar: :any,                 sonoma:        "f7adc9ef7e288ffa066325527473bd49fa6bac40ac2868a8cac8b5e7a1250eb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c695a9ca4ae5f366af1e30b73d9845d3dd1bdcd219399ab929e9bd0a401f382"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ff08f7fd803834b72297f25ae6da970f06e512a4314af3188b615479922d7c2"
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
