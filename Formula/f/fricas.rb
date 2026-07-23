class Fricas < Formula
  desc "Advanced computer algebra system"
  homepage "https://fricas.github.io"
  url "https://github.com/fricas/fricas/archive/refs/tags/1.3.13.tar.gz"
  sha256 "7ae03c0f566c4b2bbbd6da1b02965e2a5492b1b8e4f8f2f1d1329c72d44e42a2"
  license "BSD-3-Clause"
  revision 5
  head "https://github.com/fricas/fricas.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a0f868e9dcfb071a012c284d896dbd7af7c8e8328fa300d59dfb4c964d7468b9"
    sha256 cellar: :any, arm64_sequoia: "22a214629409b5fe1a3f0c1a94063de1b5f48deda82166e2d2083ecaa88b1b56"
    sha256 cellar: :any, arm64_sonoma:  "4023345922a1accd68b6e4631a3142f7ebf23b3f44293d173678b4ba646c4542"
    sha256 cellar: :any, sonoma:        "e9e6d40bd74084d32752bb232bb637e1c9b8b1cfadea4774131a2861a364052a"
    sha256 cellar: :any, arm64_linux:   "f068ce79aa474cd5c31f750fb3c26a8a532361387812a31b8309a6ab2996809a"
    sha256 cellar: :any, x86_64_linux:  "d2941d8afc546d3eed74f81a3a329fcc2a54e6a0adc1d5d814dce1a7cef0cf14"
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
