class DdnsUpdater < Formula
  desc "Lightweight universal DDNS Updater program"
  homepage "https://github.com/qdm12/ddns-updater"
  url "https://github.com/qdm12/ddns-updater/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "809407604d35bea7615bf02292f025ad46305b384a7c55c705410b4a1c0908a6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8948db1f54cbf7c4126ccf8f7d0c6ee802a2506a57126451aa1d65d614d62deb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8948db1f54cbf7c4126ccf8f7d0c6ee802a2506a57126451aa1d65d614d62deb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8948db1f54cbf7c4126ccf8f7d0c6ee802a2506a57126451aa1d65d614d62deb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2098d22125191273cc497966ef49c61ab2e36fd1169d18fc2e68213a53904a66"
    sha256 cellar: :any,                 x86_64_linux:      "6ce5e7ea9605a6a1e83d9f6f3571cd50b73fcaa57c2604f05c38c16b0fcc16e7"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/ddns-updater"
  end

  service do
    run opt_bin/"ddns-updater"
    keep_alive true
    log_path var/"log/ddns-updater.log"
    error_log_path var/"log/ddns-updater.log"
  end

  test do
    system "#{bin}/ddns-updater >log.txt & pid=$!; sleep 3; kill $pid || true"
    assert_match "INFO reading JSON config from file data/config.json", File.read(testpath/"log.txt")
    assert_match "INFO Shutdown successful", File.read(testpath/"log.txt")
    assert_match "{}", File.read(testpath/"data/config.json")
  end
end
