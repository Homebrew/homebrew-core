class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/refs/tags/v3.29.0.tar.gz"
  sha256 "5c5fd7aac8875f6e825b615d99b0890e6a9856b8647702318c32b1e43a6a1149"
  license "GPL-3.0-or-later"
  head "https://github.com/ooni/probe-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "132117e055ba6054b4a0791a5c59ca80b094bc0e68910111aa753ca31a2b1d95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d35b9e61dfc02ba4173b1303f673db3acc23fb7872af94253c15d76568f0461"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a93e0aa92e8bf9a26cfb80ac141087c824665a5770d67b063893f07d831a6c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb606d21d089fdda86cfc0e3eef4b5c671f1156a395b8c318c9998d1337585e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81ad7442bbc972fe3c8a5c4be4c891f226089f6518a09eb6209a14fb6f53a5da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "414a8e8fa70fb813587b2464c8c7b4fafab381fbdce587fa4068cc33095519f5"
  end

  depends_on "go" => :build
  depends_on "tor"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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
