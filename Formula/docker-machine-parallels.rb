class DockerMachineParallels < Formula
  desc "Docker Machine Parallels Driver"
  homepage "https://github.com/Parallels/docker-machine-parallels"
  url "https://github.com/Parallels/docker-machine-parallels/archive/v1.2.2.tar.gz"
  sha256 "01e139b33e4ceef3c3be91718088816a457cf4bf2e8d0ce16f4507780dd0ba6b"

  head "https://github.com/Parallels/docker-machine-parallels.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "31ddbcef11e3d53590b35786fe7dd5535fee66f1564fc8a975d23f7fc9cc7911" => :sierra
    sha256 "13b46654247146d7d49e97ed46567cdb4beeeb2790547e1631e67da08284456c" => :el_capitan
    sha256 "4998226a4279c54c250e66310ed6005808d74718c057a4c6f7260d8ad8309078" => :yosemite
    sha256 "e5610a0a448202b1929ffaf2edfaeb4e0b7271dfbbeb2823593e6289a2f587d6" => :mavericks
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
