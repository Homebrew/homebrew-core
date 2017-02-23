require "language/go"

class Charm < Formula
  desc "Tool for managing Juju Charms"
  homepage "https://github.com/juju/charmstore-client"
  url "https://github.com/juju/charmstore-client/archive/2.2.1.tar.gz"
  sha256 "6ec369db9dfe2b8991ef08d885477772a78d5165a49a55d542ca368898349dbe"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d17b9463753cc790e7624fadaab788bed3b998b64f3e47df6867d2766ce28c5" => :sierra
    sha256 "8aa5731bad2c9b2a915a709fc6ebeff388ed12f84a7c1cd1c4a28ec6d8949d3b" => :el_capitan
    sha256 "0421d7e7e5addcba0f62298d664c19d14ae4ea1d4469a18e76a6ffe97b4236e3" => :yosemite
    sha256 "8525b63c3eb14f480c65109f644fcfb278f0b29667e4644c69e11f80b5e334e4" => :mavericks
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
