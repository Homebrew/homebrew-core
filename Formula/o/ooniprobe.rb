class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/refs/tags/v3.23.0.tar.gz"
  sha256 "ff4717e8fd0075bcb011d738e12a47a5be17deaa0b23346f354ddd6d95fed728"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b03c68f62cdc53f336c8176f81f5b8e107cf317a3b79ee9d9083aff4ecd353f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "113d42d4783092e36169acf440ac6cd8d041a182d7909fd7ecc86afb6c55c3b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c4247526d2395b129b4d670badedc7fad394035980ff9268a2105b502d49693"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db583fd8073b3bc8347768758909b9e98516e6e0cd160e40590bdfd5ba425cee"
    sha256 cellar: :any_skip_relocation, sonoma:         "f93a68b4ea2bbea9b508800550cb0f97f798bd94c38fad34bbbbbb75c3cabc20"
    sha256 cellar: :any_skip_relocation, ventura:        "157806bdb6f5e50a2915bd3711fb5287a0f9f90d4862fcfc992252ff48cd389d"
    sha256 cellar: :any_skip_relocation, monterey:       "aa5eb7017a42cedc5b3317b49d07e45182ceb03641404bc6e3133e5ca44a2225"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3c0eea0d5b13174c5086f46bf340372f39e9d00cd00deb9e43fc9f5df6d040d"
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
