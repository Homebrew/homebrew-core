class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/refs/tags/v3.24.0.tar.gz"
  sha256 "4c2dad0367cfe3924ca45c9f484660a132e843d6c55259ff375efadeb6d518c3"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90f3093d1c71c3f456e024eb6c15624a9fa94b13a580463de7894359a3c12cb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8d137f2874730e7c9b6e9f7f38033de9211d026700ff8c3b99a1aad28dd52c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "efee84f0b4d279db5bfb2da593dcaecde4c74bfee07f4a0d6c8aea6b6c52c0e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a9029ea95fe11a5fde169d1ff1eb902ee7ac469e3f28a88bc5460772cd2ee7d"
    sha256 cellar: :any_skip_relocation, ventura:       "a2591ef98c36d99c6b25622077754f0fbef671bdc37660e689c6933d5988ed2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b013f9418249c12c12209166817ef7d1a32161acc09c9d3d41b8939f0fcb730"
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

    (testpath/"config.json").write <<~JSON
      {
        "_version": 3,
        "_informed_consent": false,
        "_is_beta": false,
        "auto_update": false,
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
          "send_crash_reports": false,
          "collect_usage_stats": false
        }
      }
    JSON

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
