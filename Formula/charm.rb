require "language/go"

class Charm < Formula
  desc "Tool for managing Juju Charms"
  homepage "https://github.com/juju/charmstore-client"
  url "https://github.com/juju/charmstore-client/archive/2.1.2.tar.gz"
  sha256 "09928a60bb4f7d8af3573ce269996417d6000e8e2bc769e4a7e6f451d264fc45"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7f01c37208e2dc35b2a9a7dcbf086377b46bde57a9cae94c5be4709c3967dd8" => :el_capitan
    sha256 "f6d6bc949aea78726fd9d6157e2e56fba441ee81589b542d09aa441e80c71f5a" => :yosemite
    sha256 "fe0839f66c66e73911f44ec0eb3cf0bcbe3f10000162a80c3db8ee3519044c61" => :mavericks
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
