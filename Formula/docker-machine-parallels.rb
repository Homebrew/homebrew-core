class DockerMachineParallels < Formula
  desc "Parallels Driver for Docker Machine"
  homepage "https://github.com/Parallels/docker-machine-parallels"
  url "https://github.com/Parallels/docker-machine-parallels.git",
      tag:      "v2.0.1",
      revision: "a1c3d495487413bdd24a562c0edee1af1cfc2f0f"
  license "MIT"
  head "https://github.com/Parallels/docker-machine-parallels.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf73fbfd0498623e7bae13c5edc3b7dd83faa8b62cc5fe81fcb23accd70fab76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1bb048b170f5ca273b7e2e3be17459a9049e29982e2a3c6c866d088772b6744f"
    sha256 cellar: :any_skip_relocation, monterey:       "dec5f7c88747688ab7395211692ced01dc6157284aed8251214ffc5147efe703"
    sha256 cellar: :any_skip_relocation, big_sur:        "4613d3ea83c5afdcd717d5027d254b5d01d4b715ed859f98b183e070bd51c9f6"
    sha256 cellar: :any_skip_relocation, catalina:       "b419812f98208b1fccbbc24f198af6a1235110203b0377d642f80886c5c5fd36"
    sha256 cellar: :any_skip_relocation, mojave:         "cce66a6fcdea79b33095c2ae7c49c93a9f730353d92738534fdbe03b3488ee43"
  end

  depends_on "go" => :build
  depends_on "docker-machine"
  depends_on :macos

  def install
    system "make", "build"
    bin.install "bin/docker-machine-driver-parallels"
  end

  test do
    assert_match "parallels-memory", shell_output("docker-machine create -d parallels -h")
  end
end
