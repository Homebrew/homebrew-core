require "language/go"

class Charm < Formula
  desc "Tool for managing Juju Charms"
  homepage "https://github.com/juju/charmstore-client"
  url "https://github.com/juju/charmstore-client/archive/2.2.1.tar.gz"
  sha256 "6ec369db9dfe2b8991ef08d885477772a78d5165a49a55d542ca368898349dbe"

  bottle do
    cellar :any_skip_relocation
    sha256 "81f53ef3cf04f02a9fd4cfba8e4d62a7617dc3f3d666e67788a6ff9242699ef1" => :sierra
    sha256 "337e5ec536c1f840aa4165b4a0167fad52bfa88ce273aabbd34b164a450853b5" => :el_capitan
    sha256 "0bb88c2873be6c396c20ff9fcf2214cc7314a12edb76e57e72a21eb02c758003" => :yosemite
  end

  depends_on "go" => :build
  depends_on "bazaar" => :build

  go_resource "github.com/kisielk/gotool" do
    url "https://github.com/kisielk/gotool.git",
        :revision => "0de1eaf82fa3f583ce21fde859f1e7e0c5e9b220"
  end

  go_resource "github.com/rogpeppe/godeps" do
    url "https://github.com/rogpeppe/godeps.git",
        :revision => "e0581207fc59197e6caa4dc03f425fdca872c4a7"
  end

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/juju/charmstore-client"
    dir.install buildpath.children - [buildpath/".brew_home"]
    ENV.prepend_create_path "PATH", buildpath/"bin"
    Language::Go.stage_deps resources, buildpath/"src"
    cd("src/github.com/rogpeppe/godeps") { system "go", "install" }

    cd dir do
      system "godeps", "-x", "-u", "dependencies.tsv"
      system "go", "build", "github.com/juju/charmstore-client/cmd/charm"
      bin.install "charm"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/charm"
  end
end
