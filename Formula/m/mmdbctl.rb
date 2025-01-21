class Mmdbctl < Formula
  desc "MMDB file management CLI supporting various operations on MMDB database files"
  homepage "https://github.com/ipinfo/mmdbctl"
  url "https://github.com/ipinfo/mmdbctl/archive/refs/tags/mmdbctl-1.4.6.tar.gz"
  sha256 "08a8033cdcb14aad77153aea3e7a2d29b8c605f2c537f23de449d30f1fe6e52f"
  license "Apache-2.0"
  head "https://github.com/ipinfo/mmdbctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "476754e99976f175f116f631a964372ea4a192de1e76e135d9fd6a6362b740d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "476754e99976f175f116f631a964372ea4a192de1e76e135d9fd6a6362b740d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "476754e99976f175f116f631a964372ea4a192de1e76e135d9fd6a6362b740d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b3dabcf4ed371bfb6d6b145026c0fd438a0654239b557cb6b12acdc0858ddc9"
    sha256 cellar: :any_skip_relocation, ventura:       "0b3dabcf4ed371bfb6d6b145026c0fd438a0654239b557cb6b12acdc0858ddc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d05493505367a7cfa87ec4475694b765b968850153a36fcfbff6488aed1fbdbe"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"mmdbctl", "completion")
  end

  test do
    resource "test.mmdb" do
      url "https://raw.githubusercontent.com/maxmind/MaxMind-DB/02de12f89048db626d04f8865c6fc76eac9a7a6b/test-data/GeoIP2-City-Test.mmdb"
      sha256 "df1eb8e048d3b2561f477cd27f7d642fc25a24767395071d782ae927036818a0"
    end

    testpath.install resource("test.mmdb")

    system bin/"mmdbctl", "verify", testpath/"GeoIP2-City-Test.mmdb"

    output = shell_output("#{bin}/mmdbctl metadata #{testpath}/GeoIP2-City-Test.mmdb")
    assert_match "GeoIP2 City Test Database (fake GeoIP2 data, for example purposes only)", output
  end
end
