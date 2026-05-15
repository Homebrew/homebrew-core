class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/refs/tags/v3.29.1.tar.gz"
  sha256 "132323f69140316f012465f7a20571b563ebff952f2b1568f815755a62ab2fb5"
  license "GPL-3.0-or-later"
  head "https://github.com/ooni/probe-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab277c27cf293aa52073b1bb33dba292e8ccbb6ca0564cdab3871c53f922225e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae91031bc77ee4fd6144f1a1fcdba4bb63facefac5735aa58e33713745fcc807"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4f5a95779862d2af3c38f53cdc93cab25a921a3ba6049647a9c8877e4fc7ae6"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c51f566a7c6c9d85980c075c592d905d66e19ad4b88dac0fa148351fa0015c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c0e8a89156b74ff0e883f845f2fe7557b9ee42bfba41af6c8edd7d508cabeaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b975e91fe4c5b5b86816b6f6d0f79d570c2b0ab950a3d32b637d4dab84c50ef"
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
