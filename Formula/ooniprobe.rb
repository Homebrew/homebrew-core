class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/v3.5.2.tar.gz"
  sha256 "56e419033715e1b2b61a82661f724148bab8fec4a28b2566a10e0a3051b3bade"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "fa6ad042547fc508eb4cb41c13e91df1b54ba95079ebb5daf1fdf17b2a23fa57"
    sha256 cellar: :any_skip_relocation, catalina: "539c5d2476da05943c9a44b668b621479ce9105a0463c6526ec7b76dfb1653bb"
    sha256 cellar: :any_skip_relocation, mojave:   "d54dcf20b1f3d0b67aafecf3086310de96bbe857c5b79e6d58c0347a21c40719"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./cmd/ooniprobe"
    (var/"ooniprobe").mkpath
  end

  test do
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
