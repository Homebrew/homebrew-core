class DockerSwarm < Formula
  desc "Turn a pool of Docker hosts into a single, virtual host"
  homepage "https://github.com/docker/swarm"
  url "https://github.com/docker/swarm/archive/v1.2.4.tar.gz"
  sha256 "ef8101033990a595ec41201fd9eb496852fd14bd25febeb7a181fd5c8bd850d3"
  head "https://github.com/docker/swarm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9995d6c8cef6f8ebd16e3640ab30847714beb365f3a08e18ff6b90e99a9acc88" => :el_capitan
    sha256 "9f411607c3b1d8df4e15ad7e15b133224379e56bce079a5b555e88ee8e3c04cd" => :yosemite
    sha256 "f9040cb2284d3d59b46597e6135ec78bf3033c3c0bcdd1535a2cf7dbdd633266" => :mavericks
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
