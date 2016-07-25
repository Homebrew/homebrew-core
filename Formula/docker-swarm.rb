require "language/go"

class DockerSwarm < Formula
  desc "Turn a pool of Docker hosts into a single, virtual host"
  homepage "https://github.com/docker/swarm"
  url "https://github.com/docker/swarm/archive/v1.2.3.tar.gz"
  sha256 "8049388fe137fb7fc17a4ccfde429f42099b8a8ace486ec4165cdeb6dfd930f7"
  head "https://github.com/docker/swarm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7337faaf8069189812deff313e47f530644b8d1be2be1f1bc526c4661767d7e2" => :el_capitan
    sha256 "4c8407769564c1c7eb67aef3efc330a5f36f7ce759eda057e8d78d93526de486" => :yosemite
    sha256 "c87ac7002c3479ab23e5a9471c629eadea2f92ebaeced10f03e04817e7340b73" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/docker/docker" do
    url "https://github.com/docker/docker.git",
      :revision => "b65fd8e879545e8c9b859ea9b6b825ac50c79e46"
  end

  go_resource "github.com/docker/libkv" do
    url "https://github.com/docker/libkv.git",
      :revision => "2a3d365c64a1cdda570493123392c8d800edf766"
  end

  go_resource "github.com/hashicorp/consul" do
    url "https://github.com/hashicorp/consul.git",
      :revision => "562bf11e9ff784824f9c5fec0ad3609805e13a3d"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
      :revision => "4fd4a9fed55e5bdee4a89d6406c2eabe38b60300"
  end

  go_resource "github.com/samuel/go-zookeeper" do
    url "https://github.com/samuel/go-zookeeper.git",
      :revision => "218e9c81c0dd8b3b18172b2bbfad92cc7d6db55f"
  end

  go_resource "github.com/docker/go-connections" do
    url "https://github.com/docker/go-connections.git",
      :revision => "34b5052da6b11e27f5f2e357b38b571ddddd3928"
  end

  go_resource "github.com/coreos/etcd" do
    url "https://github.com/coreos/etcd.git",
      :revision => "374b14e47189c249c069c9b3376cf5c36f286fa6"
  end

  go_resource "github.com/hashicorp/serf" do
    url "https://github.com/hashicorp/serf.git",
      :revision => "39c7c06298b480560202bec00c2c77e974e88792"
  end

  go_resource "github.com/hashicorp/go-cleanhttp" do
    url "https://github.com/hashicorp/go-cleanhttp.git",
      :revision => "ce617e79981a8fff618bb643d155133a8f38db96"
  end

  go_resource "github.com/Sirupsen/logrus" do
    url "https://github.com/Sirupsen/logrus.git",
      :revision => "446d1c146faa8ed3f4218f056fcd165f6bcfda81"
  end

  def install
    mkdir_p buildpath/"src/github.com/docker"
    ln_s buildpath, buildpath/"src/github.com/docker/swarm"
    ENV["GOPATH"] = "#{buildpath}/Godeps/_workspace:#{buildpath}"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", "docker-swarm"
    bin.install "docker-swarm"
  end

  test do
    output = shell_output(bin/"docker-swarm --version")
    assert_match "swarm version #{version} (HEAD)", output
  end
end
