class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/v3.15.3.tar.gz"
  sha256 "40ca23d3a08e91ff72c95e835eb59d8922bf7424464782b16d2704e8d630eecb"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98053aff9f9dd632386babeb8681430f439fb6f485d0153986a1cbf65b1b6692"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8af10899fcd7343628b6fced5992cefd2739fc9349bb9cd771992d6b89a78da8"
    sha256 cellar: :any_skip_relocation, monterey:       "844d9adca5233e51932c45c5cc039cfca9750289bc5fa2081ece89b0533292ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "6eb67906aee20bcb489e7134eaeadee934837a3628e36a6a7322cd396b974d6a"
    sha256 cellar: :any_skip_relocation, catalina:       "612ed9029e8b954045c516d33acf86d8d4e4bc2e4153e1e2eff604341aaf01e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc09c1495f3f18106d75afe4144c7845ef1b8c31073a3ba8189fd9ca7c29c8ef"
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
