class Ignite < Formula
  desc "Build, launch, and maintain any crypto application with Ignite CLI"
  homepage "https://github.com/ignite/cli"
  url "https://github.com/ignite/cli/archive/refs/tags/v28.5.3.tar.gz"
  sha256 "4ef44890f75b969829560910ffe16450541413d5604bd1b87e4544b2dc5037ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3dc5a49aeecf795471a46a6e086076f6a0ba5356eeec9ec4af30f5e1231232b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fea7bd32ea7b7f09457b2950e8b4ad4d06f4bd7b9a719739624b6d3bd47e215"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bae4d0d86be09c2dd0fdebe9b770579d88c36fc5b6a4c82909d30829a4ae50e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6ee772822f34c41e34aefae650f2def5e37906195a712aa59e6f8decb8dcd63"
    sha256 cellar: :any_skip_relocation, ventura:       "abf5f9a6ed59dec4cf6a429cee37d55981d7ae7b439999774d2dce5167106a68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a821731ad42e4866bafa3648ab3ad13a692fd8e0bc2d537ec16a505316166042"
  end

  depends_on "go"
  depends_on "node"

  def install
    system "go", "build", "-mod=readonly", *std_go_args(output: bin/"ignite"), "./ignite/cmd/ignite"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    system bin/"ignite", "s", "chain", "mars"
    sleep 2
    assert_predicate testpath/"mars/go.mod", :exist?
  end
end
