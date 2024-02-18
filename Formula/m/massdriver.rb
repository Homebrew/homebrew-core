class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/1.5.19.tar.gz"
  sha256 "8d8533a021f16e768aec810b6fa5c9409bb3b210220fc2735a9f43355b965b75"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "762cd172831c0c3dac0de3f45982f2e8d4b33c0adc8c49c006c06636cee0eafa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed07a2a84001851b5d12f943511129bb5e64bf36efb2a8fb5bc929344c9dab4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4bd3537e3115a38ab2bfc37d5b9365186d5fec68ed73b386013bf4842c2903e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8b40a0ec0fc2c6bcad76deaabd602331787346a01c25f4f4263671820b75198"
    sha256 cellar: :any_skip_relocation, ventura:        "943d34ab9893b868bb1a38c56d15636d384d8aa9a9bccd496de1fd6a89fd05a8"
    sha256 cellar: :any_skip_relocation, monterey:       "adba22e687036cce391891590c608604cc266a234e88313f195c3df95e0dcdaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c71b6448ee3fe9b68143f9618cfe4b10882be561496939a892de6b5de3784e26"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"mass")
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
