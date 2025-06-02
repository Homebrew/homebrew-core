class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/refs/tags/v3.25.0.tar.gz"
  sha256 "9222fb2d0b93ba1bf4cf7edcee7dfac6518fc622d606204724d8ed7de43fb5dd"
  license "GPL-3.0-or-later"
  head "https://github.com/ooni/probe-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f0712a91bde69b39e58c852018aa946b59553651d4e1fb34941a71993061b43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2c22444bad6411e2a1ba3c9641b62f6c52dc9c7ea9e11be14f69ed5069138b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6886c7bd5714d7538b1b498ef9836387b73c7809c84071a7c14cad22564a530d"
    sha256 cellar: :any_skip_relocation, sonoma:        "73124bf2ae34df1fb14d8437d0afd0de84b5f0c40fb6a0685d82beb183fea83f"
    sha256 cellar: :any_skip_relocation, ventura:       "38f19827d1dd5fcbc271af1292ad920cc5d326158aab620c7eb3a9d77278182d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ffa28943b2b4596d531eb77d1d382ae3a8aae98a7fb094d860d87fa220df6f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "238e11d37af2c226c2ed7f6f6dcda09c5b05600492d3f3524ed1671149b8d9b8"
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
