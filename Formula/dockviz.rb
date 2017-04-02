require "language/go"

class Dockviz < Formula
  desc "Visualizing docker data"
  homepage "https://github.com/justone/dockviz"
  url "https://github.com/justone/dockviz.git",
    :tag => "v0.5.0",
    :revision => "ee1ab834db62e5549c144f7968b81ebb167e0564"
  head "https://github.com/justone/dockviz.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f1a18e5098e54f029ed6e495d9aeffe5e56b9428be55cfff3df2103d96016093" => :sierra
    sha256 "a6e76fe6cb823309673ba0a83cd1117f1c4179e2911954a20fcd589aa54c090f" => :el_capitan
    sha256 "9b3f18e2ccb4f700ab515c002d4ae6128c9e3ebbbc0ff8796b67d3e698205214" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/Sirupsen/logrus" do
    url "https://github.com/Sirupsen/logrus.git",
        :revision => "f3cfb454f4c209e6668c95216c4744b8fddb2356"
  end

  go_resource "github.com/docker/docker" do
    url "https://github.com/docker/docker.git",
        :revision => "1704914d7cf8318a69ba9712f664cd031b6e61f6"
  end

  go_resource "github.com/docker/engine-api" do
    url "https://github.com/docker/engine-api.git",
        :revision => "de0bc7ec1a2b90b7191e63d3d6f06833188bbd85"
  end

  go_resource "github.com/docker/go-units" do
    url "https://github.com/docker/go-units.git",
        :revision => "f2d77a61e3c169b43402a0a1e84f06daf29b8190"
  end

  go_resource "github.com/fsouza/go-dockerclient" do
    url "https://github.com/fsouza/go-dockerclient.git",
        :revision => "3c8f092cb1e9d1e18a07c1d05d993e69a6676097"
  end

  go_resource "github.com/hashicorp/go-cleanhttp" do
    url "https://github.com/hashicorp/go-cleanhttp.git",
        :revision => "ad28ea4487f05916463e2423a55166280e8254b5"
  end

  go_resource "github.com/jessevdk/go-flags" do
    url "https://github.com/jessevdk/go-flags.git",
        :revision => "b9b882a3990882b05e02765f5df2cd3ad02874ee"
  end

  go_resource "github.com/opencontainers/runc" do
    url "https://github.com/opencontainers/runc.git",
        :revision => "42dfd606437b538ffde4f0640d433916bee928e3"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revsion => "3f122ce3dbbe488b7e6a8bdb26f41edec852a40b"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"dockviz"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockviz --version")
  end
end
