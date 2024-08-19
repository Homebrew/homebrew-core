class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/refs/tags/v0.10.38.tar.gz"
  sha256 "bd5e01148671ee77d37194d8dc0c58a2bb30c3faeb589915de721ab2c065deff"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7cf036190ce142db05c9118b13103029ff8b869e3bb31bdba285357b6c747824"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cf036190ce142db05c9118b13103029ff8b869e3bb31bdba285357b6c747824"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cf036190ce142db05c9118b13103029ff8b869e3bb31bdba285357b6c747824"
    sha256 cellar: :any_skip_relocation, sonoma:         "f91669463cfd1f2fc60157e5051c0b4d17d62820329d7e6fd83b4419a934d609"
    sha256 cellar: :any_skip_relocation, ventura:        "f91669463cfd1f2fc60157e5051c0b4d17d62820329d7e6fd83b4419a934d609"
    sha256 cellar: :any_skip_relocation, monterey:       "f91669463cfd1f2fc60157e5051c0b4d17d62820329d7e6fd83b4419a934d609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff10718195d324e66ee702d18eb9befc666033852fa10ccbbf4bfc84aaa4a043"
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
