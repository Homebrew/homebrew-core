class Fricas < Formula
  desc "Advanced computer algebra system"
  homepage "https://fricas.github.io"
  url "https://github.com/fricas/fricas/archive/refs/tags/1.3.13.tar.gz"
  sha256 "7ae03c0f566c4b2bbbd6da1b02965e2a5492b1b8e4f8f2f1d1329c72d44e42a2"
  license "BSD-3-Clause"
  revision 7
  head "https://github.com/fricas/fricas.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4757c100ed2611239c2c89853953cfcf391fd8b0f48809191161188d36c1e29c"
    sha256 cellar: :any, arm64_sequoia: "391057131522b1f068d42bd873a1f3c576e3eb0a60ab621cb50571ba42cd28ba"
    sha256 cellar: :any, arm64_sonoma:  "5bdae2eec1d1453b6c76bada3e786ae317edc1b9ce15c62b46fc174650930be5"
    sha256 cellar: :any, arm64_linux:   "0e874a862d5680153400acd1bf1588dfac8dc4a93e07e827c07fb5c1656d9126"
    sha256 cellar: :any, x86_64_linux:  "32efb07bb5e6c56cffcb8b3fbcb7b42493e2c2784efb3110ac6ca897205bf9d6"
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
