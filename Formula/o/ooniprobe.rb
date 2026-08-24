class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/refs/tags/v3.30.0.tar.gz"
  sha256 "8ddd7bf5f831e635dada1f8eca2db688f8da9c37e06deed03fa94826d943315b"
  license "GPL-3.0-or-later"
  head "https://github.com/ooni/probe-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1d6c03e7ba0affc399243f340b20c0555dbbfe8d35e542460a7c41107012d0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55d44d5ac9bd171ad7bce1d4c6f4bd95ddf99983785021d9f9f5935457b6ca40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85b4f3c189b5fd9260caf7453dda0a665f0f2f02baf96655aefcaa9ad2102965"
    sha256 cellar: :any_skip_relocation, sonoma:        "d47276550ae910ef4e4f793b7bbd54299735022ee9d45035c4a2975454daa044"
    sha256 cellar: :any,                 arm64_linux:   "bbd61c6d9c457821126a7f66af165b8d8ea6301fb5e82a9ab27f3761382425dd"
    sha256 cellar: :any,                 x86_64_linux:  "a41dbe1e8452e136482caf9f1597369120ae09c01e08fa35e5644257ac022663"
  end

  depends_on "go" => :build
  depends_on "tor"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "make", "userauth"

    system "go", "build", *std_go_args, "./cmd/ooniprobe"
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
