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
    sha256 "3c7a244d9941192d0cfaa0b0f57af5d584c5642376dcf5ea29314c92474b668b" => :el_capitan
    sha256 "7ce694ecb5e3a526bf1714d5ac85c502753c0b58d2e80e98fd3dee55383a6c47" => :yosemite
    sha256 "3975e86b263d019d0e298306f6ca560decf03ab88b22164ffeaac9a50bc929aa" => :mavericks
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
