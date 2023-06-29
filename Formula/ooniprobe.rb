class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/v3.18.0.tar.gz"
  sha256 "d28c050226c9282d7155da6cabf5547ddd43dc11eecacc485b6c05161c2d1d88"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef0518b5dd80cd445e6bc72b82e44caa6ca6ed93aa20858189e61193e17027d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98042eff50ef45b1d944b2ec3b29aca92623783f3aa24fc4d295e797edbc379b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69c8e86128b9ebf6749d0e3dc3f8c972a469c02bd160076e4a932d0434014341"
    sha256 cellar: :any_skip_relocation, ventura:        "f723cd8a58442f9ec534fd1dae49b071ed87b083b83d7379823480f5637cb55a"
    sha256 cellar: :any_skip_relocation, monterey:       "d817905893726f8312ea34a47db656ae3bcf157aaad93a1830d276b11099aadd"
    sha256 cellar: :any_skip_relocation, big_sur:        "e63fff719afde60d2e8adcd18ba410a584b1accbbcc9df023e4a2a9d6ec0dc54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c84d7b67ce790e5cc7b6329a2272340686157a23c14f9186c674aac5d2ad0340"
  end

  depends_on "go" => :build
  depends_on "tor"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/ooniprobe"
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
