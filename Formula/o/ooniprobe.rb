class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/refs/tags/v3.22.0.tar.gz"
  sha256 "07b03ee7e23dfbd125616c8b565009a1dde736d28f731eca722c98d7a5b67e91"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3783269edee47bb7d75a49195b274f9e21fb43d4e486b3099277420b0568ca42"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d16418fc489fb7a207fc9afabe749e8d124de71b30c82393422fc5715b16435e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "556d4bef6004d77bd695448416d5fbee076090d30a5e317b0f801201d85caab7"
    sha256 cellar: :any_skip_relocation, sonoma:         "21058caffc9deb3181a1bbf48f2ccb10975017cd271d2c19f247be23bff65900"
    sha256 cellar: :any_skip_relocation, ventura:        "bc0d31be3cc58c7e7e6f309ef63c7791a91fbcdacf9bb538fdf6475d398eabb1"
    sha256 cellar: :any_skip_relocation, monterey:       "6e18787946b83987395feed2c4d236e7f9869271b80083bb603ba6efe1108681"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da08c0378bf2b1e0e64a7d285dfc2e3c7b4d0e66d3d568b3b32cce14c4030c47"
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
