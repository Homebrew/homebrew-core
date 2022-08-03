class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/v3.15.3.tar.gz"
  sha256 "40ca23d3a08e91ff72c95e835eb59d8922bf7424464782b16d2704e8d630eecb"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91e244e01cc4850ad773e3033a4f9987bba84143d2a8bbbde0d62ef83a5036ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "821d942cebe6cbfbef339372a556dd195c9434f2e9e67334def2b6f82a814bd6"
    sha256 cellar: :any_skip_relocation, monterey:       "7669bdfde84b81c6dabe09e4a5d4103745825a4a0ca50e7d5e0358c452951cb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9e36214d183d23038020bbc0ba4e824fb331da8437d57eba6650e4325f5d819"
    sha256 cellar: :any_skip_relocation, catalina:       "17a11635a06fcff13c3e43722a0ddc37a9cd488b237d3ad8e13d506402d87b91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a56081097f07522f166118bf95f8e270ecd2fb7295470deab5a08e8666cde081"
  end

  # Required lucas-clemente/quic-go >= 0.28
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build
  depends_on "tor"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./cmd/ooniprobe"
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
