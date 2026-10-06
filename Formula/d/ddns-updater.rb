class DdnsUpdater < Formula
  desc "Lightweight universal DDNS Updater program"
  homepage "https://github.com/qdm12/ddns-updater"
  url "https://github.com/qdm12/ddns-updater.git",
    tag:      "v2.10.0",
    revision: "64996182d84adfeb7a873ea32f76b50918f90970"
  license "MIT"

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.date=#{Time.now.utc.iso8601}
      -X main.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"ddns-updater"), "./cmd/ddns-updater"
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
