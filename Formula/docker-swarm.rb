require "language/go"

class DockerSwarm < Formula
  desc "Turn a pool of Docker hosts into a single, virtual host"
  homepage "https://github.com/docker/swarm"
  url "https://github.com/docker/swarm/archive/v1.2.2.tar.gz"
  sha256 "3e7989bdbf360ae0b2fd79f2528ad81865b12bbe90a8e725bf422a26329467bf"
  head "https://github.com/docker/swarm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d728f7955fe753e0934d57c26b25a083d6ea1ab6869bfb0e7930ebfd06df97a" => :el_capitan
    sha256 "a3cdbbd02e97e8e132bc2ccbb726254d75779160fde64021d15077320aa12441" => :yosemite
    sha256 "5c52c0fcbc56a0fb498f20a6e9c461e0ae0d8b6fe3b8f1519a3a44890c00abe5" => :mavericks
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
