class Fricas < Formula
  desc "Advanced computer algebra system"
  homepage "https://fricas.github.io"
  url "https://github.com/fricas/fricas/archive/refs/tags/1.3.10.tar.gz"
  sha256 "2c1a2daaf5ce7be86118bbd1bdc2d3bd052b3e1f0ce9257dbda82cd69d25c193"
  license "BSD-3-Clause"
  head "https://github.com/fricas/fricas.git", branch: "master"

  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxau"
  depends_on "libxdmcp"
  depends_on "libxpm"
  depends_on "libxt"
  depends_on "sbcl"

  def install
    mkdir "build" do
      ENV.deparallelize
      system "../configure", *std_configure_args
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match %r{ \(/ \(pi\) 2\)\n},
      pipe_output(bin/"fricas -nosman", "integrate(sqrt(1-x^2),x=-1..1)::InputForm")
  end
end
