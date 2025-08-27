class Easytier < Formula
  desc "Simple, decentralized mesh VPN with WireGuard support"
  homepage "https://easytier.cn"
  url "https://github.com/EasyTier/EasyTier/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "5b1a33b55103e30c3762b6cbcc390a55f4a1a588b2e1cc6c3a687cb2195df7bc"
  license "LGPL-3.0-only"
  depends_on "rust" => :build
  def install
    system "cargo", "install", *std_cargo_args
  end
  service do
    run [opt_bin/"easytier-core", "--console-log-level", "warn", "-c", "#{etc}/easytier/config.toml"]
    keep_alive true
    log_path var/"log/easytier/easytier.log"
    error_log_path var/"log/easytier/easytier.error.log"
    working_dir var
    run_type :immediate
    require_root true
  end
  def post_install
    # Create config directory
    (etc/"easytier").mkpath
    # Create log directory
    (var/"log/easytier").mkpath
    # Install default config if it doesn't exist
    unless (etc/"easytier/config.toml").exist?
      (etc/"easytier/config.toml").write <<~EOS
        instance_name = "homebrew-easytier"
        instance_id = "#{SecureRandom.uuid}"
        ipv4 = "10.144.0.1/24"
        dhcp = false
        listeners = [
            "tcp://127.0.0.1:11010",
            "udp://127.0.0.1:11010",
            "wg://127.0.0.1:11013",
        ]
        rpc_portal = "127.0.0.1:15888"
        [network_identity]
        network_name = "easytier"
        network_secret = "CHANGE_THIS_SECRET"
        [[peer]]
        uri = "tcp://your.server.com:11010"
        [flags]
      EOS
    end
  end
  test do
    assert_match version.to_s, shell_output("#{bin}/easytier-cli --version")
    assert_match "full meshed p2p VPN", shell_output("#{bin}/easytier-cli --help")
  end
end
