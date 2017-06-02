class DockerMachineParallels < Formula
  desc "Docker Machine Parallels Driver"
  homepage "https://github.com/Parallels/docker-machine-parallels"
  url "https://github.com/Parallels/docker-machine-parallels/archive/v1.2.3.tar.gz"
  sha256 "3dae366290f500301872f8e7f838564df9652256b85284d93652ce5254fc14e8"

  head "https://github.com/Parallels/docker-machine-parallels.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd4f6a36ddc276cd1625e6536c4bb04ae8b639098122057dae2c34b5abe8bb5b" => :sierra
    sha256 "507cf389bd353929766b2a5fa11f03af8c2a34f229f6717878dd04860f57c58f" => :el_capitan
    sha256 "a0ea3dfca2273fe826632d3f81ee590061bfe030103a248cc802b3d42adc6d12" => :yosemite
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
