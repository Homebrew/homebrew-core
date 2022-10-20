class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/v3.16.3.tar.gz"
  sha256 "f3e86d1682a750e8dd85c519715af540abb470af4df1b3bdac42a9ed3b9d6461"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df52c647ed897a883eb6c774016d448fa28990f33eb6b6ce27bea777c5df9dab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59c1cdb87718acdb56b2eb0d8745e2994ea0690ed89a73e6b5741ec71ea25b44"
    sha256 cellar: :any_skip_relocation, monterey:       "b867d101cf6dabc15d5db0e32b5198feaf439ce31150ce28cab5d838869ddff7"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ff10b2ee43f0360e23692874ae6dcde40ad611c8ade137198ece53b684c83cf"
    sha256 cellar: :any_skip_relocation, catalina:       "f1281565050e368608dd5d324bb3a8d7dcc31fc79be0166c91506180f0decc5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bee656531b106396aa258ecca187b6bb3de1778d6fd20dc1780af1006fc3a7ac"
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
