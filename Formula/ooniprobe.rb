class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/v3.16.2.tar.gz"
  sha256 "569ddee413f9284441509ad954f6dd1c98de53add86719c28a07e54e576aaf75"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45c84b27e57565a1f0deb5a408a175281d75f8061c628975a06b7197efd033c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae06aa8ade2df928467ccbbcff51e29b3ab0129467f4b8e108fbe749fefd3200"
    sha256 cellar: :any_skip_relocation, monterey:       "026a4c3ba24d612baed3aa05b908aa37dc218751cea19b0523b6567de83f2906"
    sha256 cellar: :any_skip_relocation, big_sur:        "a21785b91308fe7cebc20e3ccd839806c9a75bff491f531d6e4d1ae434f77876"
    sha256 cellar: :any_skip_relocation, catalina:       "dcc30b2cae62ef550bf63eb1f7d100044e4cd9f6258acc64f9ad4844dd2ec144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c026dd7262632014c6fbc06bbc9fee2bddcc0a26fc5232683b0900699aa3a82"
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
