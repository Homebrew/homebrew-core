class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.148.0.tar.gz"
  sha256 "be347ed111b3e0a2987cb492e2bf1fb7ce8d06e215b6130797fd235934d21779"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5a70e6d034e967e6350b4d24d9e6790c9958036b0edc7065e2a444dd0bda86d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5a70e6d034e967e6350b4d24d9e6790c9958036b0edc7065e2a444dd0bda86d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5a70e6d034e967e6350b4d24d9e6790c9958036b0edc7065e2a444dd0bda86d"
    sha256 cellar: :any_skip_relocation, sonoma:        "01541e2955c37d7a5138aa01517bf8ab11693564ed1b917167103e2c9ae942b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64c062bbbd379ad820c0d7ad500cd15b11fa63158928f491d28007c97878911b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18eaa4dc522769603eb2132e19c604793db34e403702f611577ae3541669b3c8"
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
