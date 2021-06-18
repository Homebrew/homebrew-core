class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/v3.10.0.tar.gz"
  sha256 "0e8732c012b685d4533f608c3b0f554b89fa5834bd40a421c225789abcc47470"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b73c1e177e7a99467aea8b310f16e0feb457eb77fc07f6330e2b47139181bba1"
    sha256 cellar: :any_skip_relocation, big_sur:       "55467a50e161f783789e3f64f2900c61b8d87b5d9ae7c1d401e31843dbc9289e"
    sha256 cellar: :any_skip_relocation, catalina:      "a3a0390fb67335c4e9b9285253df4732e26f3de9ac0b5336c090c5155d713292"
    sha256 cellar: :any_skip_relocation, mojave:        "ad681ca897aff22143dcee2f94f4fada53eff9ee89d58295c41ae37dce7e20b0"
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
