class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.133.0.tar.gz"
  sha256 "d10f32abdffa82c86b34b7a03c7a96846828c87bd96ec1a8a5a86cb784a1520b"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb902bd956dee9b7eebf2354e3f079cac1e73c79b355e23f1f68832a3d5eb60c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb902bd956dee9b7eebf2354e3f079cac1e73c79b355e23f1f68832a3d5eb60c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cb902bd956dee9b7eebf2354e3f079cac1e73c79b355e23f1f68832a3d5eb60c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b141dd31ce83ddf16f362404e1cf79d5ab0a2a0621f7639657c5bb8e856111c"
    sha256 cellar: :any_skip_relocation, ventura:       "2b141dd31ce83ddf16f362404e1cf79d5ab0a2a0621f7639657c5bb8e856111c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dd6765ae95cce9005c1fb247cee232c360984c796dde9bd97c5b35b1f6210f1"
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
