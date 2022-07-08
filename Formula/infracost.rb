class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.7.tar.gz"
  sha256 "cc62bf5c3af6e42f3964aa2d149a51198b8f32cd175eafc9a8ae05c19f6b33b5"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8014fb20506a02f85267e9fda291340796a00d561e2679408abd314e8b11a6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81d9cba705f16953fd8f0d6bdf4a625759a5da647715b5d82fe68d2ce71d0d6d"
    sha256 cellar: :any_skip_relocation, monterey:       "e82bac934a70d2c563dff077b67cd3ef527efe6f9edcba45525cebef166535d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "1afa3cb30763ca40f63a3f6be574982f07b2b459667bf04e79e63be7208cb9d5"
    sha256 cellar: :any_skip_relocation, catalina:       "1afa3cb30763ca40f63a3f6be574982f07b2b459667bf04e79e63be7208cb9d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25a8fb14894ecd7db1a704ab20b402bc214df349b6ba534a5ccb3a942f360f96"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/infracost"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
