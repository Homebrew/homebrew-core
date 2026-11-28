class Beszel < Formula
  desc "Lightweight server monitoring with historical data, Docker stats, and alerts"
  homepage "https://beszel.dev"
  url "https://github.com/henrygd/beszel/archive/refs/tags/v0.21.2.tar.gz"
  sha256 "8613c593fd447b4602644a73f1ec26d5d8233fa91109192c05a2406e22316c34"
  license "MIT"
  head "https://github.com/henrygd/beszel.git", branch: "main"

  bottle do
    manifest_sha256 "14044c6ba8a1452b3809555aac90a3e099ac3d9f1ecda56e0269a1111bdef9d2"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d66754e3c8b09f85aae67d2bd4367bef82e1d746e01383379495a09f6b1ff00e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d66754e3c8b09f85aae67d2bd4367bef82e1d746e01383379495a09f6b1ff00e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d66754e3c8b09f85aae67d2bd4367bef82e1d746e01383379495a09f6b1ff00e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6a7f2d8aab5d05a6f63fa467beb2f8152362de8e535f5b404827d8a6d64c57e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c5e572d3aedd8239762a01719d177579acca28126e349850061cfe869dedb14a"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  # `test do` block runs a local server
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
    cd "internal/site" do
      system "npm", "ci", *std_npm_args(prefix: false)
    end
  end

  def install
    cd "internal/site" do
      system "npm", "--offline", "run", "build"
    end

    ENV["CGO_ENABLED"] = "0"
    ENV["GOPROXY"] = "off"
    system "go", "build", *std_go_args(tags: "no_self_update"), "./internal/cmd/hub"

    (var/"lib/beszel").mkpath
  end

  service do
    run [opt_bin/"beszel", "serve", "--http=127.0.0.1:8090", "--dir=#{var}/lib/beszel"]
    keep_alive true
    log_path var/"log/beszel.log"
    error_log_path var/"log/beszel.log"
  end

  test do
    assert_match "self-update is disabled in this build; use your package manager to update",
                 shell_output("#{bin}/beszel update 2>&1", 1)

    port = free_port
    url = "http://127.0.0.1:#{port}"
    log = testpath/"beszel.log"
    dir = testpath/"beszel_data"
    with_test_process(bin/"beszel", "serve", "--http", "127.0.0.1:#{port}", "--dir", dir, [:out, :err] => log.to_s) do
      30.times do
        break if log.read.include?("Server started at")

        sleep 1
      end
      assert_match "Server started at", log.read
      system bin/"beszel", "health", "--url", url
      assert_match "<title>Beszel</title>", shell_output("curl -fsS #{url}")
      assert_path_exists dir/"data.db"
    end
  end
end
