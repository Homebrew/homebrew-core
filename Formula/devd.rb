require "language/go"

class Devd < Formula
  desc "Local webserver for developers"
  homepage "https://github.com/cortesi/devd"
  url "https://github.com/cortesi/devd/archive/v0.6.tar.gz"
  sha256 "fdf8fbc73e1d09c968c483c0e84d58cb88f9f934a72bca3f63b7f505de69e01b"
  head "https://github.com/cortesi/devd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8eb67a434e1a225b6f8268c10f03c35b6a5f9406e9d1ef56a2573a76e4400603" => :sierra
    sha256 "69f6ea29f405429b3e74591e5ab37e68d4a27ba3c787e1361b826905c7187587" => :el_capitan
    sha256 "b2793d5f0a51ca6a1308b55f536a72fb9c505da90b6b955b86c220fc5ef7bc97" => :yosemite
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
    (buildpath/"src/github.com/cortesi/devd").install buildpath.children
    Language::Go.stage_deps resources, buildpath/"src"
    cd "src/github.com/cortesi/devd" do
      system "go", "build", "-o", bin/"devd", ".../cmd/devd"
      prefix.install_metafiles
    end
  end

  test do
    begin
      io = IO.popen("#{bin}/devd #{testpath}")
      sleep 2
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)
    end

    assert_match "Listening on http://devd.io", io.read
  end
end
