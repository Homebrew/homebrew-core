class Mmdbctl < Formula
  desc "MMDB file management CLI supporting various operations on MMDB database files"
  homepage "https://github.com/ipinfo/mmdbctl"
  url "https://github.com/ipinfo/mmdbctl/archive/refs/tags/mmdbctl-1.4.8.tar.gz"
  sha256 "373154b545a9f940738868f7e2259c89803dc966646e7b8c599d26b703424d80"
  license "Apache-2.0"
  head "https://github.com/ipinfo/mmdbctl.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb1d20f3c8c716938b346034fb20381b864ed7d6ac63ae6fc156b9eb38ad7fc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb1d20f3c8c716938b346034fb20381b864ed7d6ac63ae6fc156b9eb38ad7fc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb1d20f3c8c716938b346034fb20381b864ed7d6ac63ae6fc156b9eb38ad7fc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "980000b0e67d53d0a6b6aedf2d665ee25a24400ea07ca4b5e0544dcd9dff81f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01fec8071fa10233cc0465a6ce62a6f0870719502e89b517cf178073ca643016"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3af00b80cd2a68401e3df838b6d40bfbcdcf58b59f9f2c04eccb9144b61e17fd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"mmdbctl", shell_parameter_format: :cobra)
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
