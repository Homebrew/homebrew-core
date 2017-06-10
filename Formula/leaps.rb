class Leaps < Formula
  desc "Collaborative web-based text editing service written in Golang"
  homepage "https://github.com/jeffail/leaps"
  url "https://github.com/Jeffail/leaps.git",
      :tag => "v0.7.0",
      :revision => "5fd7c3b10c1aad9c7d35288bbaa3d350515a5472"

  bottle do
    cellar :any_skip_relocation
    sha256 "db7cb6ec0175e86c3c00e4e780c4703d7614166faaa7bf871a0e99bc5dcd0648" => :sierra
    sha256 "692eaf22f77eb233cf66dde7de168407ae17e0028ee5fb13e9bec507cfe0c035" => :el_capitan
    sha256 "071b3556faf9bbbc3c5351e0095fac21a6c3271424ae640c4ef95aadc91d5bf0" => :yosemite
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
      assert_match "You are alone", shell_output("curl -o- http://localhost#{port}")
    ensure
      # Stop the server gracefully
      Process.kill("HUP", leaps_pid)
    end
  end
end
