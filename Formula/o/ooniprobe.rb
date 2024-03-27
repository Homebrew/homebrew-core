class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/refs/tags/v3.21.0.tar.gz"
  sha256 "de43a82ea34b004f43ab18eb93da11014b8fc578f391c025749a6c9a3c7f3e3b"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b115fb6684f0818266aa3cb11c49f95e98c73b354597555db4fafc69369999f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b68eef52ba7407584e0b3ceccc840d857fadfe960fe9a1b42312220fcf27925d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a53572985bcf95e80a172326f0efffad2124d76ad62ce49b5ac779386a2a638a"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8e41fe14fb4d0d5d3cb45678d228fbd1399b68077529fe5c2763d49a0c9143d"
    sha256 cellar: :any_skip_relocation, ventura:        "0b2044048c63945f4144f7a2c619f07a8d8ebfd80069c8fe2053b0dff1dd1f1c"
    sha256 cellar: :any_skip_relocation, monterey:       "bb5db2bb12a56d850abf21f9ea1e77eaed51279330668e563472c945ef187d02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6362e759364e076954a399367802854e80266f5a20a31f6a2a4866e426f3b002"
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
