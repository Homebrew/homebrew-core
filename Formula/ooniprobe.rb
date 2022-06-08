class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/v3.15.1.tar.gz"
  sha256 "8cc06915204227f4c2b83c04d008c2ec732705ecb01aa82d13ef16ae7d51f3f8"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6175151c2c03b2ce67ee64b6e467b5a23805649bc4269261e02bf10704537c77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86d43020ae3046726ae70e6e846dfbd8abff179a0ac60ed0092e3175b5209563"
    sha256 cellar: :any_skip_relocation, monterey:       "e4a8ee479c263c4fa720b61b75b8ebcd0053d6fd3e704d45ac4d154e79b3c724"
    sha256 cellar: :any_skip_relocation, big_sur:        "9db39adc27ca6f68798393d77658e5db77320e6ce8dbcd4eae0f667df70f2cfe"
    sha256 cellar: :any_skip_relocation, catalina:       "26cc9170c9a9b3b92dc8617dd9ce94d71d032b864adee1b6899777ef88166d20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6029598cdad5d2317cb9e6b0ca25c86d6c7aae00224950491e7ea6a1cc43d96"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build
  depends_on "tor"

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
