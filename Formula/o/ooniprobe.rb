class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/refs/tags/v3.28.0.tar.gz"
  sha256 "62d9b51d0a9798b4c1b15641ab31d661b687dedd959945272c9bf6b7112476ab"
  license "GPL-3.0-or-later"
  head "https://github.com/ooni/probe-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8930c4e63a084ed287411b3a93826983fa5be2548ee3ad4b94cae178e7988ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20bfa2594793942bc840c0a63bd2ced1b2bdc0df678bda149dd1a5fff22231a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae0ad499ac54e83a2198814bc42d79455905a525c372846db37c02769bc85eb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5b3ff799d514c9eb26eba7840c570041e125205cf93d5e9d7199c04aecc07e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75405d487440a281a8e9bd17a42ca0f95f1100c3633b4187dd33187a95d5a676"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b310df82bff79b20ae770073631a5e5e3eec9ad97044bd1e42160a8e02c60cc"
  end

  depends_on "go" => :build
  depends_on "tor"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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
