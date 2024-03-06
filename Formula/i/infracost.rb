class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/refs/tags/v0.10.34.tar.gz"
  sha256 "ee4a042ba813d9d3560e1c07cf35e983e5f6bcd6961a9d041c97db808478978d"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b7cfb40f7444941de41c533e45e49d30f867288bfcc086eb67b5bf9c081fdf8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b7cfb40f7444941de41c533e45e49d30f867288bfcc086eb67b5bf9c081fdf8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b7cfb40f7444941de41c533e45e49d30f867288bfcc086eb67b5bf9c081fdf8"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f9409be7608489a29dbaa935fe226eeecb18098a342b2ebf611bab566c8639c"
    sha256 cellar: :any_skip_relocation, ventura:        "9f9409be7608489a29dbaa935fe226eeecb18098a342b2ebf611bab566c8639c"
    sha256 cellar: :any_skip_relocation, monterey:       "9f9409be7608489a29dbaa935fe226eeecb18098a342b2ebf611bab566c8639c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b852dbcead3a12e0b59fbbb614989beef2fa85c38cd57f43b475ab95d418752e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/infracost"

    generate_completions_from_executable(bin/"infracost", "completion", "--shell")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "Error: INFRACOST_API_KEY is not set but is required", output
  end
end
