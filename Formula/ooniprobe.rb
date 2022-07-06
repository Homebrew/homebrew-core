class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/v3.15.2.tar.gz"
  sha256 "75e3a51c5002ef95b1743a8836fe0a4ea252f1373dab021798f38b24f992eb75"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37f13e7a4c29fc9bb82f17af24dfbff2c5c89dcdc9d25b6fcf62c2c429c617de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "409a6da13f4c4d11e36b379d271d4766f4c7bbab6073023c051a214e0ab7df82"
    sha256 cellar: :any_skip_relocation, monterey:       "3ac29c15f0e177197e43705bf9244fedb6b3a042793a6b0a4402037e4add0bf8"
    sha256 cellar: :any_skip_relocation, big_sur:        "1462141e771a79241f3c9d441451263761469c1e7cd99feaf0a2df57ae5e4628"
    sha256 cellar: :any_skip_relocation, catalina:       "b827dfc25d78607b72cce3b8dc9a1e0f30cdd2392c83d1c8dc1eef7c91878ffe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe24a992da86bde5f1fc79f83bb2228923d6f4bf2a8ee9b99aa03d1c5e905136"
  end

  depends_on "go" => :build
  depends_on "tor"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./cmd/ooniprobe"
    (var/"ooniprobe").mkpath
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ooniprobe version")
    # failed to sufficiently increase receive buffer size (was: 208 kiB, wanted: 2048 kiB, got: 416 kiB).
    return if OS.linux?

    (testpath/"config.json").write <<~EOS
      {
        "_version": 3,
        "_informed_consent": true,
        "sharing": {
          "include_ip": false,
          "include_asn": true,
          "upload_results": false
        },
        "nettests": {
          "websites_url_limit": 1,
          "websites_enabled_category_codes": []
        },
        "advanced": {
          "send_crash_reports": true,
          "collect_usage_stats": true
        }
      }
    EOS

    mkdir_p "#{testpath}/ooni_home"
    ENV["OONI_HOME"] = "#{testpath}/ooni_home"
    Open3.popen3(bin/"ooniprobe", "--config", testpath/"config.json", "run", "websites", "--batch") do |_, _, stderr|
      stderr.to_a.each do |line|
        j_line = JSON.parse(line)
        assert_equal j_line["level"], "info"
      end
    end
  end
end
