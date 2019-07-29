class DockerMachineParallels < Formula
  desc "Docker Machine Parallels Driver"
  homepage "https://github.com/Parallels/docker-machine-parallels"
  url "https://github.com/Parallels/docker-machine-parallels/archive/v1.4.0.tar.gz"
  sha256 "2c0615f015c7d686050625f1f68c5f62b10e0f924f6126c4d31a56c17be2ef47"
  head "https://github.com/Parallels/docker-machine-parallels.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "56183f07f2f09eaae958ba5029bfd366a53a42acc40dda6685923fbd524d3dfc" => :mojave
    sha256 "c7c2c22c321fb09e28ad35576479ea27cf37aaa9a84f63983b771774aaa7dbc4" => :high_sierra
    sha256 "626f025bef7c15943215ca899dae86bd4e07926826a9eba9b7b43798a16c82ce" => :sierra
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
