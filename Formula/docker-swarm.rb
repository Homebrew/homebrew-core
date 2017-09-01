class DockerSwarm < Formula
  desc "Turn a pool of Docker hosts into a single, virtual host"
  homepage "https://github.com/docker/swarm"
  url "https://github.com/docker/swarm/archive/v1.2.8.tar.gz"
  sha256 "be8d368000e2afbe4cda87330805978bbb2d9e33cd15bc82a8669a8cd0bcd4c6"
  head "https://github.com/docker/swarm.git"

  bottle do
    sha256 "a5fa2857c0ea64376819f9983697888b2237b968e3eb301f8daf7ee291b5ce4d" => :sierra
    sha256 "5e7b222ad49eae76a5754240fd98bce22a9f795c5e8928f26d9c185e6f91f0e0" => :el_capitan
    sha256 "0b7c5090b689a6163fa3a1533a85bd3526edc75329d9536a8dd197c8556b1163" => :yosemite
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
