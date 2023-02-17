class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/v3.17.0.tar.gz"
  sha256 "b5de405f6ca6c0a0d8f630274efac7f24f54890c5571ce1f6a42849d6fa8854e"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37679340f9a5720d4d480208405ed525bc015d2ea939b566f0be232f86c18394"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59518f6f9835d5de6f2f6657c00318d436139852a949f2347f6e2a2d1db5a319"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "baf6713f41fd35f4afd8af3195576539262fbdb9711e01a2802a323fe3a755bb"
    sha256 cellar: :any_skip_relocation, ventura:        "0e62f1539a577bfcca9ac6de432a95b4f60d2588cb9a191ed39b49905cc6adad"
    sha256 cellar: :any_skip_relocation, monterey:       "951cbef30b9dd1ee9725f2552962ee848b4b2d07bfc3217755a4cf89309a7267"
    sha256 cellar: :any_skip_relocation, big_sur:        "8706b71d9cbb454e5a3ff3c6a1ced5d51338d3055987686badf2e09f151fd1bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89324bb339716a74d32e30a5236d6fbe0eca5aa855d0856466a795aa784d418f"
  end

  # Upstream does not support go 1.20 yet and recommends using a specific Go version:
  # https://github.com/ooni/probe-cli#build-instructions
  depends_on "go@1.19" => :build
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
