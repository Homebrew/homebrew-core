class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/v3.9.2.tar.gz"
  sha256 "d34dc096dfdebceaa027716fdf675eb9ab7f0085defb4235f52685d064bd5afa"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fdf33ab9bfea196a8d387f26127875300f24270e972912641e5d93c1dc27c74b"
    sha256 cellar: :any_skip_relocation, big_sur:       "68d70c24f6f6349431283304a6ca9be51eb8dfb490f7f1dba9f9b3d967631972"
    sha256 cellar: :any_skip_relocation, catalina:      "69a4ce32b2686789ff4fedb78ba0f1a6a4b6470938c63cd230122e6fe295d0fd"
    sha256 cellar: :any_skip_relocation, mojave:        "aa5c236c5d599f526376771fea019deb56811abacd3f5cf347d7a033178f04a8"
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
