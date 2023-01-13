class Cntb < Formula
  desc "Contabo Command-Line Interface (CLI)"
  homepage "https://github.com/contabo/cntb"
  url "https://github.com/contabo/cntb/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "531594632baa8bd6b0ca48e26e0da02367c52cd4777255d31b841cc9982d85c5"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3109b606b7ffde411a59cdaf76e762e12ded19377e25a064e2dd29a53e0bde7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb332a54a7e6da93e806a44dad0fb4415ab74c17901ca684624b44ca88dff685"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1d2f6a5a3d32a634a7f8d8d48f63f954762ea9f94dc9635ad207cb258290858"
    sha256 cellar: :any_skip_relocation, ventura:        "0c3e47ee91f292410cec0f62af6f62fb43ec9cd121c77aeff50143cdc74405d4"
    sha256 cellar: :any_skip_relocation, monterey:       "35c4000da95c11500888cd77cad2b2306bbd53f6d63429f2920958fba180f372"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9a8f049922224165610e2601d00ac99cac61dc905fa52cdc8b7876634c40db6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ef8f047352869005aea03052caae1570ce0e325461df39e58faadada95ef955"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X contabo.com/cli/cntb/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

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
