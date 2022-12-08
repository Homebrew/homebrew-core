class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/v3.16.7.tar.gz"
  sha256 "a019fd9e6f35a3dd4520b7d63d109e236b27121b835d901d6a7fbe12d608b070"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbde54f799ce92e075015aac9369eb85b5b44d4677b54cdebcb18b509a04b11a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9afaa9b3929d1395dacff1839f9463cdaa1e9ebfde244f7139f0b7e61e351cc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6690cd176c774a9e9dcc89139454a5cf7350ee8a3ec09e14f8c833437e90e32"
    sha256 cellar: :any_skip_relocation, ventura:        "4787f2a1ce0f5fc890d513c3de874a2704839b969454a58794ae0d854e2b967f"
    sha256 cellar: :any_skip_relocation, monterey:       "287e841f1ab850f09f498a17d62048d53b6c5ec20f65aca7c60c682cc991a4b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "487ff675456a4c7d2692bf01d7f57db1a5a28c0582f5f47f62c72c6794bdf171"
    sha256 cellar: :any_skip_relocation, catalina:       "a3fd9e6eee9672b16e5bf1e8883617b966721a1cae576a02deda698b6209fc28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81be00242327253522b19fb14195db75f1c221af7634012229c84ac011279d0b"
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
