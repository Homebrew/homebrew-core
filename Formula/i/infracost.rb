class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/refs/tags/v0.10.35.tar.gz"
  sha256 "d53c12575acb729e355b1ee04d6ef1e9927fd9a339a5359cecbf73e55c15950d"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "caf6882fca330dbd73f481755f7c05fbc06d821356e46b2780cdbb2b0ecb1950"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "caf6882fca330dbd73f481755f7c05fbc06d821356e46b2780cdbb2b0ecb1950"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caf6882fca330dbd73f481755f7c05fbc06d821356e46b2780cdbb2b0ecb1950"
    sha256 cellar: :any_skip_relocation, sonoma:         "87c011d49f4cf8b9ac90dbc56760623bc619de195e9882ac09377d4735f65c0c"
    sha256 cellar: :any_skip_relocation, ventura:        "87c011d49f4cf8b9ac90dbc56760623bc619de195e9882ac09377d4735f65c0c"
    sha256 cellar: :any_skip_relocation, monterey:       "87c011d49f4cf8b9ac90dbc56760623bc619de195e9882ac09377d4735f65c0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b6a5e4cb86baade7506fd859238cf5520fc3b95b5871d01378c42479b1d0f69"
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
