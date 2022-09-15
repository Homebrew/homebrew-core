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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2346f611ca4f2e858f70207b592de00db53e31edd9ea341881798f83e04d2d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3f0d3618bfef0104e80298201d968c2fa851afabf79b2c986260342e997bac9"
    sha256 cellar: :any_skip_relocation, monterey:       "9fe339b115445efa5213d1597ca6cc589cb0b1c9e26a8b31ed46b1f23430db93"
    sha256 cellar: :any_skip_relocation, big_sur:        "06ef2c24204c3a184e8f2197bc5e8e62e13b54d7d362543ed6650a260e066189"
    sha256 cellar: :any_skip_relocation, catalina:       "b62ba33b16e88ecf1927ad3c914ed7ad3a2121010d91064659caa5c7b7838d47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f0499ced520c82777302d614c6f1854a76858ed1e3b932d6f91dca7ac35094b"
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
