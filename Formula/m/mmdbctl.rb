class Mmdbctl < Formula
  desc "MMDB file management CLI supporting various operations on MMDB database files"
  homepage "https://github.com/ipinfo/mmdbctl"
  url "https://github.com/ipinfo/mmdbctl/archive/refs/tags/mmdbctl-1.4.10.tar.gz"
  sha256 "1588afaabface10b05a27e624b35a4113a19bd5888747fcc8505ca21b8d44149"
  license "Apache-2.0"
  head "https://github.com/ipinfo/mmdbctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7dedc0c03e9c296fab2820798814ad936a3e5f324652ebef365cccc2655cce9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7dedc0c03e9c296fab2820798814ad936a3e5f324652ebef365cccc2655cce9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7dedc0c03e9c296fab2820798814ad936a3e5f324652ebef365cccc2655cce9"
    sha256 cellar: :any_skip_relocation, sonoma:        "35fe73d2a1e19b6da5f20c9ff0e85fdbc2e0ad706372e769aea0afdac4eb63cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efae1a85d5e64015e9b17a6d9054f63596b4b4eed2e9dfa999874f42148f82f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60f326af4ab45e42920dc85ddbc4693d13f01047d675bdfad0415cccecbd5290"
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
