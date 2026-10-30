class BeszelAgent < Formula
  desc "Agent for the Beszel lightweight server monitoring platform"
  homepage "https://beszel.dev"
  url "https://github.com/henrygd/beszel/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "92dac1dd5faed2fe47fe6cdec831ccf5b04032c33438e88fc354666f563090ff"
  license "MIT"
  head "https://github.com/henrygd/beszel.git", branch: "main"

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Homebrew manages upgrades, so replace self-update with a notice
    # TODO: switch to `no_self_update` tag in the next release
    inreplace "internal/cmd/agent/agent.go" do |s|
      s.gsub! "\tchinaMirrors := pflag.BoolP(\"china-mirrors\", \"c\", false, " \
              "\"Use mirror for update (gh.beszel.dev) instead of GitHub\")\n", ""
      s.gsub! "\t\tagent.Update(*chinaMirrors)\n",
              "\t\tfmt.Println(\"Run `brew upgrade beszel-agent` to update.\")\n"
    end

    ENV["CGO_ENABLED"] = "0"
    ENV["GOPROXY"] = "off"
    system "go", "build", *std_go_args, "./internal/cmd/agent"

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
    assert_match "brew upgrade beszel-agent", shell_output("#{bin}/beszel-agent update")

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
