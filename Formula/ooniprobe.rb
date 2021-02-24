class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/v3.5.2.tar.gz"
  sha256 "56e419033715e1b2b61a82661f724148bab8fec4a28b2566a10e0a3051b3bade"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6e8b378612ee1c8062b858e5ebfeaba669992f950811ac0eb363ec4f4b7d3bc7"
    sha256 cellar: :any_skip_relocation, big_sur:       "722f55422e32fe5105948df1b67bce7aae7d369b88b2bcd120c19349d50f5bf1"
    sha256 cellar: :any_skip_relocation, catalina:      "1ba7f6ceb6f0562caa62a219e2304037a94971fd3e7296121ef8364cd70d1820"
    sha256 cellar: :any_skip_relocation, mojave:        "493b512097b808920858bcf052302d7c8d57b021d484a527cfd001b4bad94a79"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./cmd/ooniprobe"
    (var/"ooniprobe").mkpath
  end

  test do
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
