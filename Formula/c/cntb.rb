class Cntb < Formula
  desc "Contabo Command-Line Interface (CLI)"
  homepage "https://github.com/contabo/cntb"
  url "https://github.com/contabo/cntb/archive/refs/tags/v1.4.12.tar.gz"
  sha256 "78ae3f9b3f8dcbde31e34e9400e75a6c3baf849411bca37c2e523a11cfcef8f2"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "924d20cf7e8db2f345089b3c3315bbcc28e00b00ba30fbbf618866b8881679a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e1ab9027c2dde5dc506b295b78e89d987c45508858d1d1a0e68ddd6ba05ed1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22c5738f22b761c66cc326ea6eacc3e55c9ab352159c377733207ef8d228d7c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "2fb08bae34447f3ae9bd26124f9b489981bbb8c1fa5915531b670395dafc3da7"
    sha256 cellar: :any_skip_relocation, ventura:        "94708b3395b5cd7137b9f0a116ae1b450a65f827ea52bdac6e709bb73c255f21"
    sha256 cellar: :any_skip_relocation, monterey:       "8833c51cc812dd5c86cc9298d43353dd1d53ca6575ab02c5fc1d40c111be43ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "078a542fbe3548c92077026ea229fa0249aee8d75e998dcef74d6e7d6e9caa17"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X contabo.com/cli/cntb/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cntb", "completion")
  end

  test do
    # version command should work
    assert_match "cntb #{version}", shell_output("#{bin}/cntb version")
    # authentication shouldn't work with invalid credentials
    out = shell_output("#{bin}/cntb get instances --oauth2-user=invalid \
    --oauth2-password=invalid --oauth2-clientid=invalid \
    --oauth2-client-secret=invalid \
    --oauth2-tokenurl=https://example.com 2>&1", 1)
    assert_match 'level=fatal msg="Could not get access token due to an error', out
  end
end
