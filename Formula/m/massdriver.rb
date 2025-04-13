class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/1.10.6.tar.gz"
  sha256 "ff1cecbaba75ed75fb5f55b14c4d3a8c4ca4301b1592cec0658da4d0c98dc866"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2cfdafb9619fefcb66235f7a9485c6712b4bf5f4b4d8282994becf739553e65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2cfdafb9619fefcb66235f7a9485c6712b4bf5f4b4d8282994becf739553e65"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2cfdafb9619fefcb66235f7a9485c6712b4bf5f4b4d8282994becf739553e65"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b727bdd1b01c44917e97f1912e43fb8162f86f5fdfc52c3bcdcf28b9626c1c5"
    sha256 cellar: :any_skip_relocation, ventura:       "4b727bdd1b01c44917e97f1912e43fb8162f86f5fdfc52c3bcdcf28b9626c1c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "358296ed0e7e0cdbe2b048aefe53e5a7cf0c8b96dc8f19233b59568798701e75"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")

    generate_completions_from_executable(bin/"mass", "completion")
  end

  test do
    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output

    output = shell_output("#{bin}/mass bundle lint 2>&1", 1)
    assert_match "OrgID: missing required value: MASSDRIVER_ORG_ID", output

    assert_match version.to_s, shell_output("#{bin}/mass version")
  end
end
