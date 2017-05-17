class Leaps < Formula
  desc "Collaborative web-based text editing service written in Golang"
  homepage "https://github.com/jeffail/leaps"
  url "https://github.com/Jeffail/leaps.git",
      :tag => "v0.6.2",
      :revision => "578f42522a56b5da4bd4b932f199b212eeb38e0b"

  bottle do
    cellar :any_skip_relocation
    sha256 "916c0f83535614d47c9e5cae89104395155494057403c3fee38898c56c6becbb" => :sierra
    sha256 "c5ab4128388ecc8f28cd181191dbf40a2510fc771185ae7d4cc80a724edd83ea" => :el_capitan
    sha256 "7fd9a75a9e4c8e45639aba92b03a3394f65e41d4806689ca192591e37585e5f8" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    mkdir_p buildpath/"src/github.com/jeffail/"
    ln_sf buildpath, buildpath/"src/github.com/jeffail/leaps"

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
