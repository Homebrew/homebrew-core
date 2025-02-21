class Fricas < Formula
  desc "Advanced computer algebra system"
  homepage "https://fricas.github.io"
  url "https://github.com/fricas/fricas/archive/refs/tags/1.3.11.tar.gz"
  sha256 "ce74ad30b2b25433ec0307f48a0cf36e894efdf9c030b7ef7665511f5e6bf7d9"
  license "BSD-3-Clause"
  head "https://github.com/fricas/fricas.git", branch: "master"

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
      "--with-lisp=sbcl --dynamic-space-size 4096",
      "--enable-gmp",
    ]

    mkdir "build" do
      system "../configure", *std_configure_args, *args
      system "make"
      system "make", "install"
    end
  end

  test do
    # Fails in Linux CI with "Can't find sbcl.core"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match %r{ \(/ \(pi\) 2\)\n},
      pipe_output(bin/"fricas -nosman", "integrate(sqrt(1-x^2),x=-1..1)::InputForm")
  end
end
