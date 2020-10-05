class OoniCli < Formula
  desc "Next generation OONI Probe CLI"
  homepage "https://ooni.org/install"
  url "https://github.com/ooni/probe-cli/archive/v3.0.7.tar.gz"
  sha256 "01e1e1a8d7d8fff04a8c098cfd33c84c507cc6efb88c597714b4917b9d0d64e1"
  license "BSD-3-Clause"

  depends_on "go" => :build

  conflicts_with "ooniprobe", because: "old version of the client, installs binary with the same name"

  def install
    system "go", "build", "-ldflags",
            "-s -w", "-tags", "DISABLE_QUIC",
            "./cmd/ooniprobe"
    bin.install "ooniprobe" => "ooniprobe"
  end

  test do
    (testpath/"config.json").atomic_write <<~EOS
      {
        "_": "",
        "_version": 1,
        "_informed_consent": true,
        "sharing": {
          "include_ip": false,
          "include_asn": false,
          "upload_results": false
        },
        "nettests": {
          "websites_url_limit": 1,
          "websites_enabled_category_codes": ["SRCH"]
        },
        "advanced": {
          "send_crash_reports": false
        }
      }
    EOS

    assert_match "[engine] Accessible",
      shell_output("ooniprobe run websites --no-collector --config=#{testpath}/config.json")
  end
end
