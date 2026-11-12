class BeszelAgent < Formula
  desc "Agent for the Beszel lightweight server monitoring platform"
  homepage "https://beszel.dev"
  url "https://github.com/henrygd/beszel.git",
      tag:      "v0.21.2",
      revision: "c97759f0ca4badc824ab0ff43f1571cc3c8f3a72"
  license "MIT"
  head "https://github.com/henrygd/beszel.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "15db9b3e4cc882485997bb7eb828a91c3a0f094a994e85b2c03b07b92e126a8c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "15db9b3e4cc882485997bb7eb828a91c3a0f094a994e85b2c03b07b92e126a8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "15db9b3e4cc882485997bb7eb828a91c3a0f094a994e85b2c03b07b92e126a8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c87a530fc256f430c45b77c3686ad41444106055f5f5ed45a90ed157d096c03e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "96fd10a673740ee3a5e8ef257addd942bb39f19f5f5ebb207236274266ee7210"
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
