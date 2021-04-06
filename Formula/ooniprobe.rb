class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/v3.9.1.tar.gz"
  sha256 "c49ef4bbad0ce1b41add7af76bbf9345d8a47012314f1635995eea1eb3add139"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bad116f0a1d3f6de4a2f9a65b9cda01776919f799972610f3e459f28643261c0"
    sha256 cellar: :any_skip_relocation, big_sur:       "c635d255fdd1194a8b08aea3639b61ae018eada93147fb73415a057804d51016"
    sha256 cellar: :any_skip_relocation, catalina:      "ea85a87296e858c208ab0872cf990d1fdbc087b54cafbbb9465920cffb7f028f"
    sha256 cellar: :any_skip_relocation, mojave:        "68c6b38d402c83e264b36e17fec2c32557f2fb84b0a37418da83f3261af0a65e"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "./internal/cmd/getresources"
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
