require "language/go"

class Modd < Formula
  desc "Flexible tool for responding to filesystem changes"
  homepage "https://github.com/cortesi/modd"
  url "https://github.com/cortesi/modd/archive/v0.4.tar.gz"
  sha256 "3fd0c407b388703818ed580a667dec43a14c1e1c93bb196e91d0d882e5b8379d"
  head "https://github.com/cortesi/modd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0281f9cfc64de2f7d1160772163db8c3f778f8279e7a806ae80371f9dd863c3d" => :sierra
    sha256 "a828d6554f370950328513e5196f2e1778630a14dd91fb60ba71d977ad199f9a" => :el_capitan
    sha256 "49722bf8de3b711a914dffcf56fed69f1900ed4e179a7d415f8c132fe305aabb" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/cortesi/moddwatch" do
    url "https://github.com/cortesi/moddwatch.git",
        :revision => "a149019f9ed6f16033de28f66d8c1247593a0104"
  end

  go_resource "github.com/cortesi/termlog" do
    url "https://github.com/cortesi/termlog.git",
        :revision => "2ed14eb6ce62ec5bcc3fd25885a1d13d53f34fd1"
  end

  def install
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
    (buildpath/"src/github.com/cortesi/modd").install buildpath.children
    Language::Go.stage_deps resources, buildpath/"src"
    cd "src/github.com/cortesi/modd" do
      system "go", "install", ".../cmd/modd"
      prefix.install_metafiles
    end
  end

  test do
    begin
      io = IO.popen("#{bin}/modd")
      sleep 2
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)
    end

    assert_match "Error reading config file ./modd.conf", io.read
  end
end
