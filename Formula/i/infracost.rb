class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/refs/tags/v0.10.36.tar.gz"
  sha256 "7dfc849a8e91cbb81933664f8989a688365c4b627444342d15831052c976a569"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db5a47a7e1bf057db763cb81a6cfaff909f744671a7ab78cfa04573fb4650ece"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db5a47a7e1bf057db763cb81a6cfaff909f744671a7ab78cfa04573fb4650ece"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db5a47a7e1bf057db763cb81a6cfaff909f744671a7ab78cfa04573fb4650ece"
    sha256 cellar: :any_skip_relocation, sonoma:         "47175eba20f8136719b08df0e4ef32b0b58a9f45b24008dd98d9774f3df440a8"
    sha256 cellar: :any_skip_relocation, ventura:        "47175eba20f8136719b08df0e4ef32b0b58a9f45b24008dd98d9774f3df440a8"
    sha256 cellar: :any_skip_relocation, monterey:       "47175eba20f8136719b08df0e4ef32b0b58a9f45b24008dd98d9774f3df440a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d636ae45305a447a15d3440fa3058a6033dc77d982c7660b481001432f32644e"
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
