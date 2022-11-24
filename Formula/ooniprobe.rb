class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/v3.16.6.tar.gz"
  sha256 "49efc61660e61f01e613b97f8cf39e92ae012c57ba9b10184263872315a63137"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d633c9a6ece69d4a9f895b781a315006728a7634c8e029831d1ddab866619f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3cdb760cc27ab366ee78c82fb8f05b9475107ab5901f19ddfef06f5c1345e4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a390f7c970bcc259cabc7bc504bcf17112de989c4d39babe2a68f6deec89184"
    sha256 cellar: :any_skip_relocation, monterey:       "1b44a2a89bc3c70bd756dacdc65b29bfee14b6173296925bb3f98ac8249cbd62"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b527162c4ea8dc0be6d5ba0ae2d26061ad11bfaac2b72dd4a9baeac5b32f3af"
    sha256 cellar: :any_skip_relocation, catalina:       "4cda823ea7c917ff8a4761cce935533fffc499627e94540e176c8884792bd86d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdd24b58bb2d4f6391eabf2f8a3f32884e494f38c5a9bce490ef8e6f6d3e732c"
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
