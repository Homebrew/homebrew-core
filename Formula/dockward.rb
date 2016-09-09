require "language/go"

class Dockward < Formula
  desc "Port forwarding tool for Docker containers."
  homepage "https://github.com/abiosoft/dockward"
  url "https://github.com/abiosoft/dockward/archive/0.0.3.tar.gz"
  sha256 "afe9e7d8e8c6e2f60fb79516e90e7fb95b088eb444517aa5f0811f325a967a49"

  head "https://github.com/abiosoft/dockward.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd1d966081a4c5ae840ade3eac79f4df4be9778c6b5ae5c4fdcd8d556ea85e2c" => :el_capitan
    sha256 "850e0981458fa8d0ca1cbc0f6b219b5cbedfa5ed3003e90385dddca1089400c9" => :yosemite
    sha256 "581d2907f2117401cadffd2ab6b55059924b4b449eab8453eaa524101cf051ce" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/Sirupsen/logrus" do
    url "https://github.com/Sirupsen/logrus.git",
        :revision => "a26f43589d737684363ff856c5a0f9f24b946510"
  end

  go_resource "github.com/docker/engine-api" do
    url "https://github.com/docker/engine-api.git",
        :revision => "fba5dc8922bbc5098a0da24704c04ae3c4bf8b4a"
  end

  go_resource "github.com/docker/go-connections" do
    url "https://github.com/docker/go-connections.git",
        :revision => "f549a9393d05688dff0992ef3efd8bbe6c628aeb"
  end

  go_resource "github.com/docker/go-units" do
    url "https://github.com/docker/go-units.git",
        :revision => "5d2041e26a699eaca682e2ea41c8f891e1060444"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "042ba42fa6633b34205efc66ba5719cd3afd8d38"
  end

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    path = buildpath/"src/github.com/abiosoft/dockward"
    path.install Dir["*"]
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "#{bin}/dockward", "-v", "github.com/abiosoft/dockward"
  end

  test do
    output = shell_output(bin/"dockward -v")
    assert_match "dockward version #{version}", output
  end
end
