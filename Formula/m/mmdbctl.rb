class Mmdbctl < Formula
  desc "MMDB file management CLI supporting various operations on MMDB database files"
  homepage "https://github.com/ipinfo/mmdbctl"
  url "https://github.com/ipinfo/mmdbctl/archive/refs/tags/mmdbctl-1.4.9.tar.gz"
  sha256 "845f758c4be7508224093f4522d3b8932e23c1fa455b58266404c59c2e746772"
  license "Apache-2.0"
  head "https://github.com/ipinfo/mmdbctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f123304964fb7e0074e1da3e336386015519f4e6adb28a99fcc42e4a1871507"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f123304964fb7e0074e1da3e336386015519f4e6adb28a99fcc42e4a1871507"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f123304964fb7e0074e1da3e336386015519f4e6adb28a99fcc42e4a1871507"
    sha256 cellar: :any_skip_relocation, sonoma:        "94af123d96f44ede7b93c166b0e699120481c78c1c078bbcc6d9dd21f892dc97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aafb02ec3b697ca40e60a5570cfc0da2d5a2524b8a7e3d370683ac3393c9bf73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adcfcae53e37bc3eb641386e18116cdc367c5b00a735d01ac603459491e41963"
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
