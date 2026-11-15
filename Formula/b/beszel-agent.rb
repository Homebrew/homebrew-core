class BeszelAgent < Formula
  desc "Agent for the Beszel lightweight server monitoring platform"
  homepage "https://beszel.dev"
  url "https://github.com/henrygd/beszel.git",
      tag:      "v0.21.2",
      revision: "c97759f0ca4badc824ab0ff43f1571cc3c8f3a72"
  license "MIT"
  head "https://github.com/henrygd/beszel.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fe9c5eecad2bad92924633afa7cbb90af81314d54b57dbfa4b9572d039b71162"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fe9c5eecad2bad92924633afa7cbb90af81314d54b57dbfa4b9572d039b71162"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fe9c5eecad2bad92924633afa7cbb90af81314d54b57dbfa4b9572d039b71162"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a30085320ce5eebbdf48b48515675e5eeb14d4e2eb9f3220e74c7581f307d097"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "771087efd4334dd66ae60284b2f0a64db884ea81c0bcac11175655cc5223d5d0"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ENV["GOPROXY"] = "off"
    system "go", "build", *std_go_args(tags: "no_self_update"), "./internal/cmd/agent"

    (var/"lib/beszel-agent").mkpath
  end

  service do
    run [opt_bin/"beszel-agent"]
    keep_alive true
    restart_delay 5
    process_type :background
    environment_variables DATA_DIR: var/"lib/beszel-agent"
    log_path var/"log/beszel-agent.log"
    error_log_path var/"log/beszel-agent.log"
  end

  test do
    assert_match "self-update is disabled in this build; use your package manager to update",
                 shell_output("#{bin}/beszel-agent update 2>&1", 1)

    data_dir = testpath/"data"
    data_dir.mkpath
    ENV["DATA_DIR"] = data_dir.to_s

    fingerprint = shell_output("#{bin}/beszel-agent fingerprint").strip
    assert_match(/\A\h{48}\z/, fingerprint)
    assert_equal fingerprint, (data_dir/"fingerprint").read
    assert_equal fingerprint, shell_output("#{bin}/beszel-agent fingerprint").strip

    system bin/"beszel-agent", "fingerprint", "reset"
    refute_path_exists data_dir/"fingerprint"
    assert_equal fingerprint, shell_output("#{bin}/beszel-agent fingerprint").strip
    assert_path_exists data_dir/"fingerprint"
  end
end
