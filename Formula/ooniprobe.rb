class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/v3.17.1.tar.gz"
  sha256 "f8d89803c34f8f8112ed8aee2b462058fa20782e5b927f619cbf09805ec6f56d"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1dd57aa045ce0c6fca0a3dde82d010ec925e3188ebf30b0fbf1b05ea4f96745c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e7dfeac0148fb386e2d66eb37c0d77eecb28fb82cc1c83c1d17e7e66ff62b88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eac4f6d252463cb90700787205679543bf7d296c6f659d311c1422733c572c48"
    sha256 cellar: :any_skip_relocation, ventura:        "eb43f851efc036236c02360eb11f8fa047ca376a7e6f8a6c0433c0aee969df12"
    sha256 cellar: :any_skip_relocation, monterey:       "352e99ddbbbed86b7ffe59827eefd933061dae3176e88c97ed58309df3002092"
    sha256 cellar: :any_skip_relocation, big_sur:        "6bf4ff07b63cf7ee1c4489d914c6edc02044b73f2df43489c31d38cacc11be93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8d6333124c42d9dcbfd097973766b7c6e28edca8000f9a30463bb522f225c9e"
  end

  # Upstream does not support go 1.20 yet and recommends using a specific Go version:
  # https://github.com/ooni/probe-cli#build-instructions
  depends_on "go@1.19" => :build
  depends_on "tor"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/ooniprobe"
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
