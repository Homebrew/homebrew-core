require "language/go"

class Leaps < Formula
  desc "Collaborative web-based text editing service written in Golang"
  homepage "https://github.com/jeffail/leaps"
  url "https://github.com/Jeffail/leaps.git",
    :tag => "v0.6.1",
    :revision => "599d945f8f0b769de308f3e9b09df7d5fa65ee96"
  sha256 "5f3fe0bb1a0ca75616ba2cb6cba7b11c535ac6c732e83c71f708dc074e489b1f"

  bottle do
    cellar :any_skip_relocation
    sha256 "916c0f83535614d47c9e5cae89104395155494057403c3fee38898c56c6becbb" => :sierra
    sha256 "c5ab4128388ecc8f28cd181191dbf40a2510fc771185ae7d4cc80a724edd83ea" => :el_capitan
    sha256 "7fd9a75a9e4c8e45639aba92b03a3394f65e41d4806689ca192591e37585e5f8" => :yosemite
  end

  depends_on "go" => :build

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "34057069f4ab13dc4433c68d368737ebeafcccdc"
  end

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    mkdir_p buildpath/"src/github.com/jeffail/"
    ln_sf buildpath, buildpath/"src/github.com/jeffail/leaps"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "#{bin}/leaps", "github.com/jeffail/leaps/cmd/leaps"
  end

  test do
    begin
      port = ":8080"

      # Start the server in a fork
      leaps_pid = fork do
        exec "#{bin}/leaps", "-address", port
      end

      # Give the server some time to start serving
      sleep(1)

      # Check that the server is responding correctly
      assert_match /Choose a document from the left to get started/, shell_output("curl -o- http://localhost#{port}")
    ensure
      # Stop the server gracefully
      Process.kill("HUP", leaps_pid)
    end
  end
end
