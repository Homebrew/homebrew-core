class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.28.tar.gz"
  sha256 "875eb2c1a5ce43e5f782716d99727fb4e59a98da148c8f99177ffd3b7864406d"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "781b96763beadff9c7de5b614e9ef7e2dc404d318e0a9b385c66f2cf569354e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "781b96763beadff9c7de5b614e9ef7e2dc404d318e0a9b385c66f2cf569354e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "781b96763beadff9c7de5b614e9ef7e2dc404d318e0a9b385c66f2cf569354e5"
    sha256 cellar: :any_skip_relocation, ventura:        "fa5569ea61057f518123a1668ad07f0fd0c94a130ac62f17bb54b0e56bd6dd3c"
    sha256 cellar: :any_skip_relocation, monterey:       "fa5569ea61057f518123a1668ad07f0fd0c94a130ac62f17bb54b0e56bd6dd3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa5569ea61057f518123a1668ad07f0fd0c94a130ac62f17bb54b0e56bd6dd3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ffa81e259edd4b70ab7c496d8b26c72b85f5eec182f6a3e5daf44f7733fc824"
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
