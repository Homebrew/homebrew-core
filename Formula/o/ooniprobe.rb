class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/refs/tags/v3.21.1.tar.gz"
  sha256 "30aeb00da6b2d1217cea3409c7f47b60765a6b1df96aa59474649a54c6d3edf6"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "422530e5ec4e21a31537702e93aa60ffbf822fbb4ec8ab8cb5eb15f602891ab8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d5b652dba0ad79d8190b1d84b1f60ebb65980267f5bef3b386f435a905bc870"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "961a58e6bd5830c505240be4fba4e843902442985759f0a73d24e0f5f91c48e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb1c39f8f79246714a9c7ccea31581f621302364c4f6f07d09a52f519ad12643"
    sha256 cellar: :any_skip_relocation, ventura:        "a7c352390a7b065d12646d51ec3737d84776eae655f5ce88f27c024c321275bd"
    sha256 cellar: :any_skip_relocation, monterey:       "5377a44c8266d1f90f11db5ece9307b858828c9653adde753b8740b45500f356"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c19d5c35adad5fbe569a967df40dc9ef4185ce65cd35e5bdb7e2338f0ca9cdb"
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
