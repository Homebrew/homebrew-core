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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "31452cb0cddac474389a2b6a5455062d450d7c23fbb8220f381aa3f461aae0cc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2b2d73c6c941cd763e3207456c78ccde085b34dd9e02661fe113deaf0f2592b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a358f6c53f72dce48d40754f9255635d5eee86471a80c0335d9e79c5e831bda9"
    sha256 cellar: :any,                 arm64_linux:       "4db8948493284477b26f2321482df107269f6dbf66000c1c7b396bb6257b0a3f"
    sha256 cellar: :any,                 x86_64_linux:      "ea3fdc6a53bc1c59e5c06134fb8cbed5fae2d08b9c731121fe128b0c774bf391"
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
