class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/v3.17.5.tar.gz"
  sha256 "6e0f7c1fb725943c74dacc799389ebe8d042238cde32b3d5b8f1dbfa04b10880"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab444bbf7ecca493aa3f9d661d36dd059bad69f6cd3ea47bfd4f188562df85cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef7bd2c52cd7fbfb0f67d2f11fd6130bac1635ab93f16d1f674d16c8facdaea7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "044954dc9435a2e10d7cb4031a260937671f3d8c9bb9ffa57a66b38957a455ca"
    sha256 cellar: :any_skip_relocation, ventura:        "b5edceb20b8817f4c64104d4d6d1580b8e4a7b39c382056823a8bcebd9b3e3fe"
    sha256 cellar: :any_skip_relocation, monterey:       "0d4fd4e82e97b71a066f13d72338f6d8d0c8cfed0f5d1e95cb6ac6f8f470436b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba27dcbaed8024f81ae696bc98fb20ad7158c2be683f0430ad4f0da3cd89c50d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13f1edd487410a316dc5d372634dc1984b673c60140ea11b77f89fd3e11c8246"
  end

  # Upstream does not support go 1.20 yet and recommends using a specific Go version:
  # https://github.com/ooni/probe-cli/blob/v#{version}/GOVERSION
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
