class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/refs/tags/v3.27.0.tar.gz"
  sha256 "840184371851109191db848ed83df07a13370ff56afb7f340dd6fa4431e9de9c"
  license "GPL-3.0-or-later"
  head "https://github.com/ooni/probe-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4542e06cf84f76ae47764bb4b54b0082d111335084731085314dc2deb5e98ee4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "504e85cca82a6af8e95a540dd391cdb7b53133cdd23e0ca067f9ab43de9ef42a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91c13e30ee2d22a3c8bcd453a399c414d8621bdb839017bcb2ae689d5c84384b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea32d6af789ca14709fabbf5d734d3a2e9f23004855966e873a97da300e658e5"
    sha256 cellar: :any_skip_relocation, ventura:       "731513dd8fad24b94749cc303ad65ffc27d7c934ab570960756a75f463c73596"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f10df49b70b16f546ca3ac2c3249f2b5fe5528a7ae0e8d7f53f6520ea329e04e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc67b181e65d7bf90276c6af62daf06c239a8a8c865746d32d504dc54399629e"
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
