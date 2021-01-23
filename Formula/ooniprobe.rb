class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/v3.3.0.tar.gz"
  sha256 "f5b7473a9a67ee3c4c417651359939b3933256af10bb2019b12176fb7c249c11"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "9a5d8c8b6bda3609642113631ba7c39b2cbf4fc27b09bd4b2fccc832befdd3e5" => :catalina
    sha256 "e8e120b4342f22d48efbcfa45cde2faa28c9edd045121373f3b2ba8349e1d6fc" => :mojave
    sha256 "3e13549c0175e9f3167f24526ed0c45bd7096b84c0360042654be9b4dff980f7" => :high_sierra
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
