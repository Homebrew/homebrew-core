require "language/go"

class Charm < Formula
  desc "Tool for managing Juju Charms"
  homepage "https://github.com/juju/charmstore-client"
  url "https://github.com/juju/charmstore-client/archive/2.2.0.tar.gz"
  sha256 "ce4c9dc8b03fbb6047d95217626c4218bba798083da16399691a32bba98647c2"

  bottle do
    cellar :any_skip_relocation
    sha256 "8aa5731bad2c9b2a915a709fc6ebeff388ed12f84a7c1cd1c4a28ec6d8949d3b" => :el_capitan
    sha256 "0421d7e7e5addcba0f62298d664c19d14ae4ea1d4469a18e76a6ffe97b4236e3" => :yosemite
    sha256 "8525b63c3eb14f480c65109f644fcfb278f0b29667e4644c69e11f80b5e334e4" => :mavericks
  end

  depends_on "go" => :build
  depends_on "bazaar" => :build

  go_resource "github.com/kisielk/gotool" do
    url "https://github.com/kisielk/gotool.git",
        :revision => "94d5dba705240ba73ce5d65d83ce44adc749b440"
  end

  go_resource "github.com/rogpeppe/godeps" do
    url "https://github.com/rogpeppe/godeps.git",
        :revision => "c00f01a737f4f06e397ca86f67341cc345507221"
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
