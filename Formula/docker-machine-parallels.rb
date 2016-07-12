class DockerMachineParallels < Formula
  desc "Docker Machine Parallels Driver"
  homepage "https://github.com/Parallels/docker-machine-parallels"
  url "https://github.com/Parallels/docker-machine-parallels/archive/v1.2.1.tar.gz"
  sha256 "e32a5f384d1677d5318c2e7c3478e216134ee3d7633c1c2d444974b3449c53ce"

  head "https://github.com/Parallels/docker-machine-parallels.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "132cdaa80f3679215eda9c8dea39064cd4a7a5bd4959b48f0e1ba6d2b4f353aa" => :el_capitan
    sha256 "02d9ef4bbe59431a7cb5086e56c07c698ad8dda45bfb9d7eadbee86fc5bcd489" => :yosemite
    sha256 "3d7abed590fdfc6f5d4f73b6d13aa1ba6512ff386921ab51b2363b647e5aef38" => :mavericks
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
