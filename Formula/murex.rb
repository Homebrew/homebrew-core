class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/v2.11.2200.tar.gz"
  sha256 "31930f6ddc1b44a08352e79b8b6afdca2b47ce6e30057e839ccfe06f68a45fe9"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f5f5a8a645188119729a929fb69a015d055cd7b1c6cd0bd592601742c618175"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "362f47131a27ea71ada1661efd4cec2921fab17d9ac595174f60b044ac073eaa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a996b11b0960be6f41f4aafcb5cc628cce2d40ca7c9a8207200e87e37adce557"
    sha256 cellar: :any_skip_relocation, ventura:        "937a1c1fd4cb91dd754e3629cc1519c73200c3af79570dd57faeb486efa30fd8"
    sha256 cellar: :any_skip_relocation, monterey:       "bf029d3bb3fae5747d377e347c6d76c494b5029000cf5c49fca03ca0e1caa987"
    sha256 cellar: :any_skip_relocation, big_sur:        "c28182d5c15f27bc98626aed744496670e4be9ffe11582ce026f75985cf98f01"
    sha256 cellar: :any_skip_relocation, catalina:       "a3a7ee87b5ce052f04c45df32a0023f68ed45b44a6a4b99fe329db7d44a77d3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2a5dc86edc34c3877665d2e8ebaa3882a69ebb92e8fd6840071359a2ab37136"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/murex", "--run-tests"
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
  end
end
