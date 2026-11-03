class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/refs/tags/v3.31.1.tar.gz"
  sha256 "3bea44234f620073ba2510001c06e5345e5f27ecea03e6750adbac00e9d82c88"
  license "GPL-3.0-or-later"
  head "https://github.com/ooni/probe-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "11e6a463f3481b6d3e3a885cdf68e3d7bbe7bb1e30bb9e07e7b15e7978612de1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "86c390f8b0f456178742ec603be4bfac35be28c10d1edcd447ea9935fd0ab55d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6d4bebb6826d17522ebeeba957b13fe0b6bb362cb322e58d8158c566050f0cc3"
    sha256 cellar: :any,                 arm64_linux:       "ad6812091a515f89e72eaac66e32ceccbe26995e82a606d1d630ff3c4e9b6720"
    sha256 cellar: :any,                 x86_64_linux:      "722732095602a21a87de8409723156adeae81fb137c65c386766a23885cc9a25"
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
