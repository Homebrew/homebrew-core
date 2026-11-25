class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "ea902efc3f02f75af78424ff76b12b422efbf4da13c018f54420a73712bfe6b1"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    manifest_sha256 "94e11f5acdc4b1dcb06eafd78175be2278a4f4c0bb60017f28511e702f20a9f7"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "542fd2ab130b42a0a6a90c3224d48bde3fd8225ff614b8ea09b5bb3dfad2a2b3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "542fd2ab130b42a0a6a90c3224d48bde3fd8225ff614b8ea09b5bb3dfad2a2b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "542fd2ab130b42a0a6a90c3224d48bde3fd8225ff614b8ea09b5bb3dfad2a2b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ba2badccdc7795994dfb9d29e5ddb82dfe6ef3d676fa9b77d61a879b787f3e1a"
    sha256 cellar: :any,                 x86_64_linux:      "22d16c10ac2e28223abdee0ae914e04a12151e0a8b8e7604f4dbff7ec14c6f97"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
