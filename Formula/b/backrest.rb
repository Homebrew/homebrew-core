class Backrest < Formula
  desc "Web UI and orchestrator for restic backup"
  homepage "https://github.com/garethgeorge/backrest"
  url "https://github.com/garethgeorge/backrest/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "0ad29fe41a821fa7dff1bc37cdbd681c5c60dff503141b81b82ba517a0f8b913"
  license "GPL-3.0-only"

  depends_on "go@1.24" => :build
  depends_on "goreleaser" => :build
  depends_on "node@24" => :build

  def install
    cd "webui" do
      system "npm", "i"
      system "npm", "run", "build"
    end

    cd "cmd/backrest" do
      ENV["CGO_ENABLED"] = "0"
      system "go", "build", "."
      bin.install "backrest"
    end
  end

  test do
    system bin/"backrest", "-h"
  end
end
