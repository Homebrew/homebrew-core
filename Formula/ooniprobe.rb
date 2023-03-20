class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/v3.17.1.tar.gz"
  sha256 "f8d89803c34f8f8112ed8aee2b462058fa20782e5b927f619cbf09805ec6f56d"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9b84a55e43d123c793ae150cb1cbe9c469af78547489c6b16792999778ec081"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d50dd20e462d685bb8393920107627d6081e8e1c7075291983fc317792037eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0547b7df9e3ad444c6e2176f6b42b1bbe899e1bbcfd52eea8ca2c27d4b75afe"
    sha256 cellar: :any_skip_relocation, ventura:        "e56a9eeeb6a6ba3755170172fc576a806eaa21cda9428521ef5a1cc47a3e03a2"
    sha256 cellar: :any_skip_relocation, monterey:       "3d2aeb22f38db37d04982122baceadf2d50a91dc02a1893b18c54c3dcb7f594f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3440be6d6ceb12dd450b0b32b51a80d031a930b5042c5b4a5f54a1654af1857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e73b2552f6a37d33303766b095e9980c7c0d69b7200cbac70a214ae432c53457"
  end

  # Upstream does not support go 1.20 yet and recommends using a specific Go version:
  # https://github.com/ooni/probe-cli#build-instructions
  depends_on "go@1.19" => :build
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
