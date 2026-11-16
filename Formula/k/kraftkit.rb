class Kraftkit < Formula
  desc "Build and use highly customized and ultra-lightweight unikernel VMs"
  homepage "https://unikraft.org/docs/cli"
  url "https://github.com/unikraft/kraftkit/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "7e9c1f7e0d83e245987517892af64bdf555c76818ecd61d28a2d6620252ea8cc"
  license "BSD-3-Clause"
  head "https://github.com/unikraft/kraftkit.git", branch: "staging"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ec1933301c640ae5dd838d241073f112248579f1dda402cf5dff9ee82dc0f10f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d0b9ce31aa08cba5553da4ed4f9791a2bf3eb4c9462d9ae6f1803856b848170f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a32631fe978c42ccba8406ec320af0058e2afacd2c3a1a261e85ff6d66884fc3"
    sha256 cellar: :any,                 arm64_linux:       "5aaf30a2e1058717c77572be9967b7460e6a40c65174440c3c95a8e8a8e56225"
    sha256 cellar: :any,                 x86_64_linux:      "2f14959d7cfc5a89e5c423f7fa42dcd7511cfc32577fbb72fe3ecb3a761e14b6"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[
      -X kraftkit.sh/internal/version.version=#{version}
      -X kraftkit.sh/internal/version.commit=#{tap.user}
      -X kraftkit.sh/internal/version.buildTime=#{time.iso8601}
    ]
    tags = %w[containers_image_openpgp exclude_graphdriver_btrfs netgo osusergo]
    system "go", "build", *std_go_args(ldflags:, tags:, output: bin/"kraft"), "./cmd/kraft"

    generate_completions_from_executable(bin/"kraft", shell_parameter_format: :cobra)
  end

  test do
    expected = "finding 1 unikraft.org/helloworld:latest"
    assert_match expected, shell_output("#{bin}/kraft run unikraft.org/helloworld:latest 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/kraft version")
  end
end
