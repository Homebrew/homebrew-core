class Mmdbinspect < Formula
  desc "Look up records for one or more IPs/networks in one or more .mmdb databases"
  homepage "https://github.com/maxmind/mmdbinspect"
  url "https://github.com/maxmind/mmdbinspect/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "589cf517b61b3837ae59a5b4875db30974dfcaee6c533ee91768286967ade8e8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/maxmind/mmdbinspect.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32ea559ea3db8ed663b41e20b5d3db3c3982fd92acfcec7235de26b3be73bb9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32ea559ea3db8ed663b41e20b5d3db3c3982fd92acfcec7235de26b3be73bb9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32ea559ea3db8ed663b41e20b5d3db3c3982fd92acfcec7235de26b3be73bb9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5d866271963d5a0a7152f47a41e8b1da2046e2f7e395287d65c3f1cb2cf78f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "657f79c53a27815dbbc4ef247beae40307111f4d814d9751e1f3e02aec247bfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "807a8b443eb151b0c5e9fa87b7cff7af1df3f8255d5b3ab8d067ac7e422f50df"
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
