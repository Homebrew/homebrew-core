class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.9.16.tar.gz"
  sha256 "f22776d297465ecd1c00520ee4f138d68d9e765c380e020096484d9260806e41"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fb88dfa66780d506fed3f5beeb091bce9802ff1c7f0e8dddf3b09eb86adf60c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fb88dfa66780d506fed3f5beeb091bce9802ff1c7f0e8dddf3b09eb86adf60c"
    sha256 cellar: :any_skip_relocation, monterey:       "2c3c19823588cae14e62c971167c3a1792ef500e67c416ac8474bcb15c17422c"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c3c19823588cae14e62c971167c3a1792ef500e67c416ac8474bcb15c17422c"
    sha256 cellar: :any_skip_relocation, catalina:       "2c3c19823588cae14e62c971167c3a1792ef500e67c416ac8474bcb15c17422c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73f38c76dc6dd7457916876f46ba69df926115ca250f757cd893f1e91aa49f63"
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
