require "language/go"

class Dockward < Formula
  desc "Port forwarding tool for Docker containers."
  homepage "https://github.com/abiosoft/dockward"
  url "https://github.com/abiosoft/dockward/archive/0.0.4.tar.gz"
  sha256 "b96244386ae58aefb16177837d7d6adf3a9e6d93b75eea3308a45eb8eb9f4116"
  head "https://github.com/abiosoft/dockward.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c9da754f2dc8bf05869375a7db39a8fb2aec0a0c8aae0990469626ed3d55d751" => :sierra
    sha256 "dd1d966081a4c5ae840ade3eac79f4df4be9778c6b5ae5c4fdcd8d556ea85e2c" => :el_capitan
    sha256 "850e0981458fa8d0ca1cbc0f6b219b5cbedfa5ed3003e90385dddca1089400c9" => :yosemite
    sha256 "581d2907f2117401cadffd2ab6b55059924b4b449eab8453eaa524101cf051ce" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/Sirupsen/logrus" do
    url "https://github.com/Sirupsen/logrus.git",
        :revision => "61e43dc76f7ee59a82bdf3d71033dc12bea4c77d"
  end

  go_resource "github.com/docker/distribution" do
    url "https://github.com/docker/distribution.git",
        :revision => "7a0972304e201e2a5336a69d00e112c27823f554"
  end

  go_resource "github.com/docker/engine-api" do
    url "https://github.com/docker/engine-api.git",
        :revision => "4290f40c056686fcaa5c9caf02eac1dde9315adf"
  end

  go_resource "github.com/docker/go-connections" do
    url "https://github.com/docker/go-connections.git",
        :revision => "eb315e36415380e7c2fdee175262560ff42359da"
  end

  go_resource "github.com/docker/go-units" do
    url "https://github.com/docker/go-units.git",
        :revision => "e30f1e79f3cd72542f2026ceec18d3bd67ab859c"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "f2499483f923065a842d38eb4c7f1927e6fc6e6d"
  end

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/abiosoft").mkpath
    ln_s buildpath, buildpath/"src/github.com/abiosoft/dockward"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "install", "github.com/abiosoft/dockward"
  end

  test do
    output = shell_output(bin/"dockward -v")
    assert_match "dockward version #{version}", output
  end
end
