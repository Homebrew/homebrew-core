class DockerMachineParallels < Formula
  desc "Docker Machine Parallels Driver"
  homepage "https://github.com/Parallels/docker-machine-parallels"
  url "https://github.com/Parallels/docker-machine-parallels/archive/v1.3.0.tar.gz"
  sha256 "dcfd9fefde15ba0e5d264b7f3efdb76cdd14e59fe722a28fff82f3a418f78d8b"
  head "https://github.com/Parallels/docker-machine-parallels.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d857c9a9d06ac47c2c3394793dbc9f504c6e7cf32e26c4455d481b682d2ff05f" => :mojave
    sha256 "90e5ca2fee7e338fa70402ba154176f24d2229cfbde1f17cc7839509cd0992e2" => :high_sierra
    sha256 "6d6a4d6f286b19135036505469e8a1d917751ab1365ee18ddc0f08e640f6ce13" => :sierra
    sha256 "4bc09895e88b6c5ca296c4fec0ae708d7675d7372b03781a7aa91de140032ae6" => :el_capitan
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
