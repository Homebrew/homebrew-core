class Has < Formula
  desc "Checks presence of various command-line tools and their versions on the path"
  homepage "https://github.com/kdabir/has"
  url "https://github.com/kdabir/has/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "0e73552dbf59e3da0d9254da87c94599595c9ea07c69a62a4853e69bbf3f0d7d"
  license "MIT"
  head "https://github.com/kdabir/has.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1b267d61b91d1ca227e2d207b891dad3025976b2615a5f49fb33a3971feb117b"
  end

  def install
    bin.install "has"
  end

  test do
    assert_match "has v1.4.0", shell_output("#{bin}/has")
  end
end
