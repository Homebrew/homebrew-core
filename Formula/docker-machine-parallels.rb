class DockerMachineParallels < Formula
  desc "Parallels Driver for Docker Machine"
  homepage "https://github.com/Parallels/docker-machine-parallels"
  url "https://github.com/Parallels/docker-machine-parallels.git",
      tag:      "v2.0.1",
      revision: "a1c3d495487413bdd24a562c0edee1af1cfc2f0f"
  license "MIT"
  head "https://github.com/Parallels/docker-machine-parallels.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "43448ab3d84fa30ea33242cbbe0e9bc87f8d4c873272d5c2ea9f5704b659a80b" => :big_sur
    sha256 "e9232de0aa3b564d52c7caffbe57240213f940e6cf44df8dcdb48483c35670ba" => :arm64_big_sur
    sha256 "bccbce2df5d50177efc369a84f52e8ceb35e9e1d1c140aaa671d220a018e6feb" => :catalina
    sha256 "32455b74320269c8d50cc3db1916eedca0013dd500e766ba5d56c57897a955a5" => :mojave
    sha256 "a2b35f8457b064eb6a86bae1af28708730fbf3ad4a23007aa197375fb404b8ba" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "docker-machine"

  def install
    system "make", "build"
    bin.install "bin/docker-machine-driver-parallels"
  end

  test do
    assert_match "parallels-memory", shell_output("docker-machine create -d parallels -h")
  end
end
