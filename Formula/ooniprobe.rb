class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/v3.14.1.tar.gz"
  sha256 "8bb85d526fae0ec544b3766e6e988e696e83252aed24a29e4de8c10f5beb094e"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "629c52976e62f9ce99bc355a5c4a0a7b68884c35a58409496191418218283a63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9626936e5028a5768f5617e7b49629245c7f2849499b19cfa8232a39085402e6"
    sha256 cellar: :any_skip_relocation, monterey:       "09ba9ecd9ee4d359dbb23d31042acf6ac1c5551a58676f132488a6ccc36ac2c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "7aacfc5035440c50d1107374fde821133da1c8f30f1d1bee2e1a04c103827c41"
    sha256 cellar: :any_skip_relocation, catalina:       "931f92c33c4bdf58ba336d738e631baed9ad00c45a9d0e69e06c095c4ef66f06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1a9d290ccdcdbef535ddd9eca13dc7b184b8702e0fd132b3c7c31192618dab8"
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
