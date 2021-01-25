class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/v3.4.0.tar.gz"
  sha256 "e573cc6496860b75c02d35a1829c220c9c8062350f2178fce208698538bb3ced"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "96ec812187f18df0ce2b892275f712495167d5b07441325f3d19ab043c0e3352" => :big_sur
    sha256 "aa5c27c834a0cd256f31536c6c186cf15304e22331774c83da6961c22145473d" => :catalina
    sha256 "e8726380e93d3c6df0138fa764da071c10d7ad6add4a59ad19962941930438dc" => :mojave
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
