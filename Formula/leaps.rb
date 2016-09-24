require "language/go"

class Leaps < Formula
  desc "Collaborative web-based text editing service written in Golang"
  homepage "https://github.com/jeffail/leaps"
  url "https://github.com/Jeffail/leaps.git",
    :tag => "v0.5.0",
    :revision => "5cf7328a8c498041d2a887e89f22f138498f4621"
  sha256 "5f3fe0bb1a0ca75616ba2cb6cba7b11c535ac6c732e83c71f708dc074e489b1f"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "fa920e95afa37d1a2690e3d5ac2cd6010f0b8c67f56c989250c542867cfc8825" => :el_capitan
    sha256 "dcaf8dd1314c3b3d1b3e904e7c37f3b251cd5d3e7fc5e58fc49bec09418a9c29" => :yosemite
    sha256 "b7d162e71b1daa2ff79218c0ea9caf51f8bd0f6d003c7c605c713f76a559daf1" => :mavericks
  end

  depends_on "go" => :build

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "db8e4de5b2d6653f66aea53094624468caad15d2"
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
