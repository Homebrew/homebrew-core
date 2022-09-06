class Netclient < Formula
  desc "Automate fast, secure, and distributed virtual networks using WireGuard"
  homepage "https://netmaker.io"
  url "https://github.com/gravitl/netmaker/archive/v0.15.0.tar.gz"
  sha256 "cd6f595365dd409400a61b6e7220133d0ea281db1ecc38ac541bc929f748d53e"
  license "SSPL-1.0"
  head "https://github.com/gravitl/netmaker.git", branch: "master"

  depends_on "wireguard-tools"
  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X 'main.version=v#{version}'"), "netclient/main.go"
  end

  def caveats
    <<~EOS
      Netclient requires a daemon to function properly.
      This daemon needs to run as root, and can be enabled using:
        sudo brew services start netclient
    EOS
  end

  service do
    run [opt_bin/"netclient", "daemon"]
    keep_alive true
    environment_variables PATH: "#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin:/usr/sbin:/sbin"
  end

  test do
    output = pipe_output "'#{bin}/netclient' 2>&1"
    assert_match "This program must be run with elevated privileges", output
  end
end
