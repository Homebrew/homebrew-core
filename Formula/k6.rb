class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/v0.38.3.tar.gz"
  sha256 "3ee4b4892a9965c336efc97b3fc9e179be0652331aecaf79e90d42dce8825c26"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "feb9c885fe5ea6b50578f9c608b23777e48412b9961f8630eb685f1dde850107"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd196b9b847ee0e49f00e742b35c1360b011e06341c5ba48ba637d5843abb490"
    sha256 cellar: :any_skip_relocation, monterey:       "d3717782e5fb24587050139e4fac8017951cc5fd502286556ccb92915d3ec6d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "9fa64f8a5a880ba17b59b9e12e0f1eaf07a8b8415ce8a2b1ebe2d52531e7c6e0"
    sha256 cellar: :any_skip_relocation, catalina:       "483274ee66db9324e9ac7151277feb0cccd4750494c9d097f08ed859f2f31b58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4954a957e0841a64d7bd4211857217539e544f4909684102d480695b1d0540f8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"whatever.js").write <<~EOS
      export default function() {
        console.log("whatever");
      }
    EOS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")
    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end
