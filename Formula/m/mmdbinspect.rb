class Mmdbinspect < Formula
  desc "Look up records for one or more IPs/networks in one or more .mmdb databases"
  homepage "https://github.com/maxmind/mmdbinspect"
  url "https://github.com/maxmind/mmdbinspect/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "7031c9df103b78f6cc1e441dec7bff80743bae79935bf0694a8d9c1f2d0d6cab"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/maxmind/mmdbinspect.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2867196560667fcee30a9b9fb30f38651ffd7e7ac1ab6f352d32d3a9521997a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd2ecd32e2d64c6d4b35cfbdf57eeb8cf2c4f79385da300fa791b9e6cac0c449"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "258a073b818c60576f4042913ee4053c632deae2ca47435ed930ebd5057ba945"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08aa384d6799f3e05954f79ed0f1c92a0bbb96f0fc731aff03978f8a5e687d61"
    sha256 cellar: :any_skip_relocation, sonoma:         "138f33a523623a3dafb7a96da79b98987f58abd46ac50bb8b87469bd9d81a289"
    sha256 cellar: :any_skip_relocation, ventura:        "5a8fd7d5ea482aee83bd485cd07782368efaa034643b8829e8a965906a6c233f"
    sha256 cellar: :any_skip_relocation, monterey:       "16793974693aa4a49b65689bd728af00fd109c1b6c6476c27c9ad7d4ce591eba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec2a1905e63afdb38e62d24f3f4841e81ddf75f09ec102becab9415b10a81a23"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/mmdbinspect"
  end

  test do
    resource "homebrew-test-data" do
      url "https://raw.githubusercontent.com/maxmind/MaxMind-DB/507c17e7cf266bb47bca4922aa62071cb21f6d06/test-data/GeoIP2-City-Test.mmdb"
      sha256 "7959cc4c67576efc612f1cfdea5f459358b0d69e4be19f344417e7ba4b5e8114"
    end

    testpath.install resource("homebrew-test-data")

    output = shell_output("#{bin}/mmdbinspect -db GeoIP2-City-Test.mmdb 175.16.199.1")
    assert_match "Changchun", output
  end
end
