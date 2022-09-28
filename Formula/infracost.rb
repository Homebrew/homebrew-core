class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.12.tar.gz"
  sha256 "026948076935a51e37d00cce1536338f61ceac5c4838fcbd189e0fab721befc3"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d8e5808eea2bdc037d2a8499a7310619e8fdfbc35b84bd0c82b1dc041ec915b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9b0c0f38cd38f5b1c2f628f1ac7848a7c8f91aa8bf7a0ae5ff5d7b3b3bb66c3"
    sha256 cellar: :any_skip_relocation, monterey:       "7bcdd5d1a2e3be14e4a0d43a225ccbff419ebdf05f166461221f6d8944cd8776"
    sha256 cellar: :any_skip_relocation, big_sur:        "0cbc0c55a5c5f6eaeab67deb836cec2a4f4c7fd33da0d6c725d9dba4c3bbcd83"
    sha256 cellar: :any_skip_relocation, catalina:       "7bcdd5d1a2e3be14e4a0d43a225ccbff419ebdf05f166461221f6d8944cd8776"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74130113c0ba0ba28c8f524fe5bec245bf7e5acc7b2f918ad6be09b3a7fa524c"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/infracost"

    generate_completions_from_executable(bin/"infracost", "completion", "--shell")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
