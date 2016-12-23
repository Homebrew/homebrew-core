require "language/go"

class Devd < Formula
  desc "Local webserver for developers"
  homepage "https://github.com/cortesi/devd"
  url "https://github.com/cortesi/devd/archive/v0.7.tar.gz"
  sha256 "c1d2f102e017da92bf6c333ba90c305eb90085aec342a69e7a7889b3b685da96"
  head "https://github.com/cortesi/devd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dbb234b88eb380412693ab3cbb6af17a02332cef0792115e105cd6cf082468e1" => :sierra
    sha256 "00fbd50456eff0ef1af172402f79863b1ce968136edcb961e38a520e171d4195" => :el_capitan
    sha256 "77c15338932c82b878d738d79a227054c63cbb32c428e9c85c43a13c91436152" => :yosemite
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
