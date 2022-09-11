class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/v3.16.1.tar.gz"
  sha256 "c38a322337d8378f959563162cdc43e806e13e1089af799373fdeeccbcac2a8b"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5502b26b540527209b3bcda0838531aa436698cc7067130a9b7ed73aa46ee5e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddcbb49e282e443c142f48849dd96efaf81e82aaf5e070846f6c115aa0accf40"
    sha256 cellar: :any_skip_relocation, monterey:       "05d4641217b5a03548597b771711079f99d5709d0cdce2c36ede7f40c5685b46"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb6d50c12718756effe6540f66af779af28d1f281f74719d522702a3d720cc13"
    sha256 cellar: :any_skip_relocation, catalina:       "7daab0fb1e5a8e0d4995d84024b4dc5e950f5be317b76e7e84c37b151923b2a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6d7749dba57ee470af3b0ba2fff819fd5b653e263e3a137ca495be140d16e9d"
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
