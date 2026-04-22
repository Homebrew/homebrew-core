class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.155.0.tar.gz"
  sha256 "aaaf9ddfd6770241e4b6f0e821fc0316fa76ee2c4615c0bc32518a23c608d924"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b90a97265bfb8ee517fa23b1ebdf3eacaf02d574aae024f5c723751f20d4d245"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b90a97265bfb8ee517fa23b1ebdf3eacaf02d574aae024f5c723751f20d4d245"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b90a97265bfb8ee517fa23b1ebdf3eacaf02d574aae024f5c723751f20d4d245"
    sha256 cellar: :any_skip_relocation, sonoma:        "52cfe9d23a26a6a703e81e09fea8aa15f3cf1883d98173f497fe17089e6dea16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33149660f8d33ea174a374060af33b6fd425aad24d8e2dc6dc64237334af8c31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70436eef359238e624d00d4e20e211ff67558bb478bbf67db1360fcee3ce002d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/digitalocean/doctl.Major=#{version.major}
      -X github.com/digitalocean/doctl.Minor=#{version.minor}
      -X github.com/digitalocean/doctl.Patch=#{version.patch}
      -X github.com/digitalocean/doctl.Label=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/doctl"

    generate_completions_from_executable(bin/"doctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
