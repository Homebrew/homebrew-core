class Openvi < Formula
  desc "Portable OpenBSD vi for UNIX systems"
  homepage "https://github.com/johnsonjh/OpenVi#readme"
  url "https://github.com/johnsonjh/OpenVi/archive/refs/tags/7.2.20.tar.gz"
  sha256 "9bb7538f7381fd2d2bdc574f98bb154052b302200b1976203714086b007bf511"
  license "BSD-3-Clause"
  head "https://github.com/johnsonjh/OpenVi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "818fc76b3a70aa89390df6e4414b995e62df8b30e4a6735a5e94e6e90b86646d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f77826d22e53f6ba8e692828ff4679c920f5404a07705878848855d1c39d97a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04c37a69480a7b73b6ca0e8b66a36fa3a83863b69d898bd8012abfc5a5a085c1"
    sha256 cellar: :any_skip_relocation, ventura:        "bd6be64438dd5f5f75dda82b06c922d94d712d6bea550ac82fcae4732f515471"
    sha256 cellar: :any_skip_relocation, monterey:       "c641d7bd5557eed1d51e011e2c6f8bc7d88313c7ce567c5877a8e577d9e1507c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5b2ed2abf35c097cbc825a684aa5b49759d0f53748e58f1a2c8337bfb9abbc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1f682b542e09c747dc252509731ecef02d8599f0aa68d503fb25a9da906b20e"
  end

  uses_from_macos "ncurses"

  def install
    system "make", "install", "CHOWN=true", "LTO=1", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test").write("This is toto!\n")
    pipe_output("#{bin}/ovi -e test", "%s/toto/tutu/g\nwq\n")
    assert_equal "This is tutu!\n", File.read("test")
  end
end
