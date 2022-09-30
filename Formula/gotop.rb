class Gotop < Formula
  desc "Terminal based graphical activity monitor inspired by gtop and vtop"
  homepage "https://github.com/xxxserxxx/gotop"
  url "https://github.com/xxxserxxx/gotop/archive/v4.2.0.tar.gz"
  sha256 "e9d9041903acb6bd3ffe94e0a02e69eea53f1128274da1bfe00fe44331ccceb1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e31c03674afecf694b8a81a7aa7e4b58380233cc1be6485c7217458eb54d0035"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a90066ac1768b3501a9cc3def21145171cfb9f902a380393b6bd5af512588c18"
    sha256 cellar: :any_skip_relocation, monterey:       "9b37342aa125d059b04d0cbef2bf1a43b06254a20c9d482798fefd6f4405b9e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "6992fc66b85405c15f7f3cb2b189e6f101eedb8ab217e045826c7da387799bf3"
    sha256 cellar: :any_skip_relocation, catalina:       "0afef67d52edc325041d1ee6e6b9b1533b61894537e1a4f71b4b43825d1b252f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c481add3eaa9d62b18b6e5d64959e3cdcd80178917ab8ba6f1768b821481032e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.Version=#{version}
      -X main.BuildDate=#{time.strftime("%Y%m%dT%H%M%S")}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/gotop"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gotop --version").chomp

    system bin/"gotop", "--write-config"
    conf_path = if OS.mac?
      "Library/Application Support/gotop/gotop.conf"
    else
      ".config/gotop/gotop.conf"
    end
    assert_predicate testpath/conf_path, :exist?
  end
end
