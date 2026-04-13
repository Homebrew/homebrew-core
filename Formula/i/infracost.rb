class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/refs/tags/v0.10.44.tar.gz"
  sha256 "638ac6155c15886bcdc1eda4f633ae54f64243f61b8b8676791e0003ddd836d7"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12a68a6ec410dd1883c8cf5a63b594631678cead882d7af914f0a5a08d3df06f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12a68a6ec410dd1883c8cf5a63b594631678cead882d7af914f0a5a08d3df06f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12a68a6ec410dd1883c8cf5a63b594631678cead882d7af914f0a5a08d3df06f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e86f96207d558bac70c4a3dda6961cffdb918d33a415fef56cb29fdd77d60cdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "177cd3e7ebf2c55adc1e241e0df892e02e8607b0cba1ef8914825fa97255f155"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a31d56b9fc59a944c1f56dc2afb2edf9d56cc491f46a02e42d72bd3d9ce7558"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/infracost"

    generate_completions_from_executable(bin/"infracost", "completion", "--shell")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "Error: INFRACOST_API_KEY is not set but is required", output
  end
end
