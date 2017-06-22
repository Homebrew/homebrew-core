class Leaps < Formula
  desc "Collaborative web-based text editing service written in Golang"
  homepage "https://github.com/jeffail/leaps"
  url "https://github.com/Jeffail/leaps.git",
      :tag => "v0.8.0",
      :revision => "31af03df6678b72dd46b31ea53a1825b38b15ab6"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa9cf3e9eac808b4a137e5140bcc524f8581d87a1cf9f80e1ec32a78020ae3ff" => :sierra
    sha256 "6057a6539732b2b7967ca6678981560b19f0cb5bd96557b6bd930f1922272abc" => :el_capitan
    sha256 "e056193127c7d1c48aa01934ea4e3c0301a7124a9c7fa46d82a34e1f9cd20e28" => :yosemite
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
