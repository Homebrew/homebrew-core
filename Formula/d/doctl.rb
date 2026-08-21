class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.167.0.tar.gz"
  sha256 "1e0e1ccf5bb16984b49c1f7556a6d496449f7675c28534030e7c8084c7459894"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cae0e3c82f433ef22424d71359a82edac974d666ab7c939855204c88dbe519f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cae0e3c82f433ef22424d71359a82edac974d666ab7c939855204c88dbe519f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cae0e3c82f433ef22424d71359a82edac974d666ab7c939855204c88dbe519f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "6894a217979f1d6e2d3d6c5fd5c2f374580d9ebc78efa8d6eba4cda838f2dff6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "094efb0a81a0e950a55f97a5b96f141064988ba79e9a626f47e4002b1fa395e0"
    sha256 cellar: :any,                 x86_64_linux:  "f4caf83d2793f982660a5884ac09bb9256a5c0c77d746c3ad530de2191313d0d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
