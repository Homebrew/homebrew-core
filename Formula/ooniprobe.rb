class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/v3.16.5.tar.gz"
  sha256 "198f7a3507482bfbf0fb24c24f34e17c9f5adbfdf5d8c63774ecd816708a4438"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "710dc5160b9ec80798b158b924146e821ba5173d0d7c7f33fe0f1be0965b5f58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b4218db83cc0c41338a365473ca25e858955f6af7baecafbeba5fe2bcf72fe9"
    sha256 cellar: :any_skip_relocation, monterey:       "1ca354f2357cb182d2048c85b81a6bb0ecc767e506d06435453094e7c9720765"
    sha256 cellar: :any_skip_relocation, big_sur:        "6aaba5e289a9e6734184d3512712c75a39cb403f9705d97a591a4e64780befd9"
    sha256 cellar: :any_skip_relocation, catalina:       "e8197fbcb25363f14b960c2114d2a17bb9cc7cbdc9b196e9d008ed1a2c41022b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9becaff0d91006c82c94cc95a858b58d512cfed47ff75fb6a5cf89091d9cd28c"
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
