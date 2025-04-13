class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.124.0.tar.gz"
  sha256 "19ad2d9ca14a4269926179cd91de1c62aba92a2dc4919da504469ba16054c48c"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84d7fe542be7f68095a0f0ef50f060a06c54aaaa774aabd2f1a7a7234670b59b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84d7fe542be7f68095a0f0ef50f060a06c54aaaa774aabd2f1a7a7234670b59b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84d7fe542be7f68095a0f0ef50f060a06c54aaaa774aabd2f1a7a7234670b59b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5819a9c7eab7e86001ad62e3eb5f4ef4cd18bbec9c01e4693fc1cc6aadbabe5"
    sha256 cellar: :any_skip_relocation, ventura:       "e5819a9c7eab7e86001ad62e3eb5f4ef4cd18bbec9c01e4693fc1cc6aadbabe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13700d3193b23614fdabeaa8945d29de2b7e37945b7bb316f81ff38d59c30b1f"
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
