class DockerMachineParallels < Formula
  desc "Docker Machine Parallels Driver"
  homepage "https://github.com/Parallels/docker-machine-parallels"
  url "https://github.com/Parallels/docker-machine-parallels/archive/v1.2.2.tar.gz"
  sha256 "01e139b33e4ceef3c3be91718088816a457cf4bf2e8d0ce16f4507780dd0ba6b"

  head "https://github.com/Parallels/docker-machine-parallels.git"

  bottle do
    sha256 "0115d3906faa6b3590d083b0def25833ce6d10502b8a3582525c638ed915e959" => :sierra
    sha256 "fcf1945a764b4e0b5e2496c401b123a57791b2d99df36dff605219cec9b43f58" => :el_capitan
    sha256 "a421d0f9c45151edd11dd43b06ddf17fa92a36aeb894beb8fbbf64ed4c505ba7" => :yosemite
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
