class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/v3.10.1.tar.gz"
  sha256 "2b81c14133f39ac91c4ea6761be7a27d768cd88989b52ae72376d1d7b69de322"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb7cd7169ba6aec0328574528a405a1b037fb9039f642a3a5e87144ec13eea72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "746cd38569b353bd25d8984e90b83754c7ec5c1ee48417ff007d43a8a935fb5e"
    sha256 cellar: :any_skip_relocation, monterey:       "36f081fc1520b637fb18f032eef6cbdfb706ff8cf5daa0f3e11507d5a1a38b2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "89e6b871207538537ae7dfd73c5cd40885aad95e2440fce531100df0b4957dd5"
    sha256 cellar: :any_skip_relocation, catalina:       "b8268996f24122c5bf53c27b225f5fca1b8cd16b217eb8ecdf8395aabead0348"
    sha256 cellar: :any_skip_relocation, mojave:         "6e049ae4eb2529c020aa4dd5d09fcfdde562a05b99f9ad41a9183ac38dab8054"
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
