class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.133.0.tar.gz"
  sha256 "d10f32abdffa82c86b34b7a03c7a96846828c87bd96ec1a8a5a86cb784a1520b"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f566a050902b70437e8547a7daddf9dd4838698bc5d244507dbcebb774a67b62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f566a050902b70437e8547a7daddf9dd4838698bc5d244507dbcebb774a67b62"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f566a050902b70437e8547a7daddf9dd4838698bc5d244507dbcebb774a67b62"
    sha256 cellar: :any_skip_relocation, sonoma:        "66c4825dd5d1dd3753e690b1392513d7d28f2ef3d723da2537ead70501b17423"
    sha256 cellar: :any_skip_relocation, ventura:       "66c4825dd5d1dd3753e690b1392513d7d28f2ef3d723da2537ead70501b17423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a09057a2823a58e9b815751c9cc52a105889e0d163eab12331f2c8674c0b9695"
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

    generate_completions_from_executable(bin/"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
