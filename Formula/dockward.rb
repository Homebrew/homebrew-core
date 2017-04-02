require "language/go"

class Dockward < Formula
  desc "Port forwarding tool for Docker containers."
  homepage "https://github.com/abiosoft/dockward"
  url "https://github.com/abiosoft/dockward/archive/0.0.4.tar.gz"
  sha256 "b96244386ae58aefb16177837d7d6adf3a9e6d93b75eea3308a45eb8eb9f4116"
  head "https://github.com/abiosoft/dockward.git"

  bottle do
    sha256 "e77f0df02e1274ac0d0582fd34bfe3e99af51a2118a6784cbaec184845d79318" => :sierra
    sha256 "773227e5fd26363c4eebb218a93eb1369aaaee1c034d5d771fd32d1d06b86b3d" => :el_capitan
    sha256 "6a60b36dc4b343c62f37968b52ff1287eeff7168a6f651736bfa61ced0824587" => :yosemite
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
