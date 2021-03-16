class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/v3.7.0.tar.gz"
  sha256 "27f0eec380825f236f7ab3aff22dd29d7090ef47d1ce1ccb1e728e0b846b30ce"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8febc99962cd25a8a448198c8837f62a82add56b7011505ba487ca4bfc4450fd"
    sha256 cellar: :any_skip_relocation, big_sur:       "5f34b6c2d134075598168d4865a2e44bea47a7320f27a4a352b33c3000e5547a"
    sha256 cellar: :any_skip_relocation, catalina:      "cf2c12e4144baa698d11f121b3f862b9b07a0691ee23aae2b2c8e330269f9376"
    sha256 cellar: :any_skip_relocation, mojave:        "310bb173502552cf62532c82d5cfa888f0ff6d1550b2377bd612bc6e8dfe92b1"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "./internal/cmd/getresources"
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
