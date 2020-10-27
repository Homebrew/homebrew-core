class DockerMachineParallels < Formula
  desc "Parallels Driver for Docker Machine"
  homepage "https://github.com/Parallels/docker-machine-parallels"
  url "https://github.com/Parallels/docker-machine-parallels/archive/v2.0.1.tar.gz"
  sha256 "af52903482bff0f13200cc5aca39037cd8625cc663120e1e4d3be13aeda2720d"
  license "MIT"
  head "https://github.com/Parallels/docker-machine-parallels.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bccbce2df5d50177efc369a84f52e8ceb35e9e1d1c140aaa671d220a018e6feb" => :catalina
    sha256 "32455b74320269c8d50cc3db1916eedca0013dd500e766ba5d56c57897a955a5" => :mojave
    sha256 "a2b35f8457b064eb6a86bae1af28708730fbf3ad4a23007aa197375fb404b8ba" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "docker-machine"

  def install
    ENV["GOPATH"] = buildpath

    path = buildpath/"src/github.com/Parallels/docker-machine-parallels"
    path.install Dir["*"]

    cd path do
      system "make", "build"
      bin.install "bin/docker-machine-driver-parallels"
    end

    prefix.install_metafiles path
  end

  test do
    assert_match "parallels-memory", shell_output("docker-machine create -d parallels -h")
  end
end
