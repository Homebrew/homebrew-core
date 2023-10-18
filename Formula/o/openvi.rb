class Openvi < Formula
  desc "Portable OpenBSD vi for UNIX systems"
  homepage "https://github.com/johnsonjh/OpenVi#readme"
  url "https://github.com/johnsonjh/OpenVi/archive/refs/tags/7.4.24.tar.gz"
  sha256 "c79c87021c059fbd234578741f623f28aead5b3355edf0e677995d76b10b741b"
  license "BSD-3-Clause"
  head "https://github.com/johnsonjh/OpenVi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2466f20f1d64f88d63e78c5397461567d3b1c39a46f831154918a87528ba617d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "221c19b4e56c0efaf2f06c15bee4db54c8a79e087f549ccf1a0706c33faffbcf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31825e80c2594ed8eb0ddfdbf8c88734543eab46183a0461deeb6f081209762a"
    sha256 cellar: :any_skip_relocation, sonoma:         "fed82408980303b3f0e3ef63b03d2d7fee34452536952e57db5c55252b18dd5c"
    sha256 cellar: :any_skip_relocation, ventura:        "61bf40acd6a801d317884380358e4dd8440ef50e9826eb9e128214d2549878cc"
    sha256 cellar: :any_skip_relocation, monterey:       "16d65b2f620bbd0880a96f3d66c2553f6de989cad4019514b68907209f4ff469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de6c42a723376184900f14f844d4571c40b86f8d44a759e852d99dc2c26fcef3"
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
