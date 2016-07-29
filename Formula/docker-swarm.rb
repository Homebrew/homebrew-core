class DockerSwarm < Formula
  desc "Turn a pool of Docker hosts into a single, virtual host"
  homepage "https://github.com/docker/swarm"
  url "https://github.com/docker/swarm/archive/v1.2.4.tar.gz"
  sha256 "ef8101033990a595ec41201fd9eb496852fd14bd25febeb7a181fd5c8bd850d3"
  head "https://github.com/docker/swarm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7337faaf8069189812deff313e47f530644b8d1be2be1f1bc526c4661767d7e2" => :el_capitan
    sha256 "4c8407769564c1c7eb67aef3efc330a5f36f7ce759eda057e8d78d93526de486" => :yosemite
    sha256 "c87ac7002c3479ab23e5a9471c629eadea2f92ebaeced10f03e04817e7340b73" => :mavericks
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
