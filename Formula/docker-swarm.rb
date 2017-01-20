class DockerSwarm < Formula
  desc "Turn a pool of Docker hosts into a single, virtual host"
  homepage "https://github.com/docker/swarm"
  url "https://github.com/docker/swarm.git",
      :tag => "v1.2.6",
      :revision => "508b331683331a0421bdc48979a0a16885ba4e7c"

  head "https://github.com/docker/swarm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "be0111eb686c63e1c886a3d8d4fafe02e39fc6eb89672dbcaa319912d2abadb3" => :sierra
    sha256 "45d6f0f20397387536400f61d810f53ae335f53be1ac2ada67c80dd7b7d6cef2" => :el_capitan
    sha256 "31cd5e9596234041a912e2cdcee6f434a0a9552b53307df0d80eca5676833543" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/docker/swarm").install buildpath.children
    cd "src/github.com/docker/swarm" do
      system "go", "build", "-o", bin/"docker-swarm"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-swarm --version")
  end
end
