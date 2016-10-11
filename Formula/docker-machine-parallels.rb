class DockerMachineParallels < Formula
  desc "Docker Machine Parallels Driver"
  homepage "https://github.com/Parallels/docker-machine-parallels"
  url "https://github.com/Parallels/docker-machine-parallels/archive/v1.2.1.tar.gz"
  sha256 "e32a5f384d1677d5318c2e7c3478e216134ee3d7633c1c2d444974b3449c53ce"

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
