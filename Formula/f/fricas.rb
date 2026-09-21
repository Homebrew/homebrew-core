class Fricas < Formula
  desc "Advanced computer algebra system"
  homepage "https://fricas.github.io"
  url "https://github.com/fricas/fricas/releases/download/1.3.13/fricas-1.3.13-full.tar.bz2"
  sha256 "dd4d5e06db0ba4a43a5bfb64e94f6c8d4b10e68ac65a77556891a6b24af148a2"
  license "BSD-3-Clause"
  revision 7

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a5bf832a22e111827203875402746117838a7e8f18de9b92da4e6ebf94030494"
    sha256 cellar: :any, arm64_tahoe:       "4757c100ed2611239c2c89853953cfcf391fd8b0f48809191161188d36c1e29c"
    sha256 cellar: :any, arm64_sequoia:     "391057131522b1f068d42bd873a1f3c576e3eb0a60ab621cb50571ba42cd28ba"
    sha256 cellar: :any, arm64_sonoma:      "5bdae2eec1d1453b6c76bada3e786ae317edc1b9ce15c62b46fc174650930be5"
    sha256 cellar: :any, arm64_linux:       "0e874a862d5680153400acd1bf1588dfac8dc4a93e07e827c07fb5c1656d9126"
    sha256 cellar: :any, x86_64_linux:      "32efb07bb5e6c56cffcb8b3fbcb7b42493e2c2784efb3110ac6ca897205bf9d6"
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
