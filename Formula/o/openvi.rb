class Openvi < Formula
  desc "Portable OpenBSD vi for UNIX systems"
  homepage "https://github.com/johnsonjh/OpenVi"
  url "https://github.com/johnsonjh/OpenVi/archive/refs/tags/8.0.34.tar.gz"
  sha256 "27cab6f631f1d8aefc33c944a3f226ebb8d5ad4325f50b6f52d60be7b823ded8"
  license "BSD-3-Clause"
  head "https://github.com/johnsonjh/OpenVi.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a8f456479ef2c1176bb171bddd2a284e24575cc877847dc2504f5a3f2dda4ac0"
    sha256 cellar: :any, arm64_tahoe:       "b278d6789c2a83808ef9e48e604f0fd368a7807fbff4b9526ec46840b88ab526"
    sha256 cellar: :any, arm64_sequoia:     "241bd2cc5c703e7d4a47dea961df55ac529c516c51486aed245f6c9d849ea475"
    sha256 cellar: :any, arm64_linux:       "4bb82ef0124cfadba4b92f0c2065fb2b90d8e6769017cb0fd967e033a186560e"
    sha256 cellar: :any, x86_64_linux:      "c300971558c7a4c825c8f07f2c93727afe234a6779bb34aca15fec007fa29fbb"
  end

  depends_on "pkgconf" => :build
  depends_on "ncurses" # https://github.com/johnsonjh/OpenVi/issues/32

  def install
    system "make", "install", "CURSESLIB=-lncurses", "CHOWN=true", "LTO=1", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test").write("This is toto!\n")
    pipe_output("#{bin}/ovi -e test", "%s/toto/tutu/g\nwq\n")
    assert_equal "This is tutu!\n", File.read("test")
  end
end
