class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/refs/tags/v3.26.0.tar.gz"
  sha256 "5250e159c599912b9a5fde5a385a6e1a32a9a657afd7282586778bf65cfbd4b7"
  license "GPL-3.0-or-later"
  head "https://github.com/ooni/probe-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c8616371a8663be0ce979f2173dd09710efd09cfdf23c90ad6606331fb8faa8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e89b34cdb4151945d1d422b9977712575f76c6a0350bc069cf229648dc1d8d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f1465c143773fa313979c27a9a84da9fefd62d9540bd2477695d6b993c80378"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e3f07f8356ce7a9d1fbbed7351d189b51d6eac3acbd43c254eef65e77baefc3"
    sha256 cellar: :any_skip_relocation, ventura:       "6149338ac009e6b37a428aabba3d1b527ccbcfa43b362ee5e1c343513adae575"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b78404ace41dffd45d7dea82f61bd1850a6058418045d43910214a5d1dc7646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f7c112e9ca02159ae023735a575bc7b3fb98a6e6d74c61e509a67971ac6ea01"
  end

  depends_on "go" => :build
  depends_on "tor"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/ooniprobe"
    (var/"ooniprobe").mkpath
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ooniprobe version")

    # failed to sufficiently increase receive buffer size (was: 208 kiB, wanted: 2048 kiB, got: 416 kiB).
    return if OS.linux?

    (testpath/"config.json").write <<~JSON
      {
        "_version": 3,
        "_informed_consent": false,
        "_is_beta": false,
        "auto_update": false,
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
          "send_crash_reports": false,
          "collect_usage_stats": false
        }
      }
    JSON

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
