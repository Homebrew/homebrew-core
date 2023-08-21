class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/v3.18.1.tar.gz"
  sha256 "7a2b77e6fb303bcdf80e269aa3c8c71e273d2af7c940580d5623a668d1d094e2"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d493c5821e7c0265c8275e25dd6b943e39fef56f2c7004436c083caad49bad59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a477c4e5b6ffc8c13f5ebbe980315dfea7e2ff88bafa101a03731cf18a455344"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9788a1bec0c68727fb1be1584655bceccd779184cc9df0dab733513e2d0668bd"
    sha256 cellar: :any_skip_relocation, ventura:        "bb0c9deb311a6efd3421005d612d176aa0f962ea8b8acecb76c827f67d97cf57"
    sha256 cellar: :any_skip_relocation, monterey:       "1c55c6b83ba096a2dc93302ede2fae39459eaaa6d9f888b7a4be48c1290ee5d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "1aa8c8b8d76d26e7a5515a7c599f168dc13acf93b3d5eede5454ef2df372587a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc04d4e62efc3b7c5799c01be559569b72d8c50dd084f6d667fe0a33ef373447"
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
