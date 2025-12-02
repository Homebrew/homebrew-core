class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.147.0.tar.gz"
  sha256 "e1e6f3ad172821a73446c8eb4997f19d122f5a9baff1a4ad2385c98f539325c6"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "720fef6d9a046337810d4e59a17da200a58d1954471e9fd397c05ffb35540d25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "720fef6d9a046337810d4e59a17da200a58d1954471e9fd397c05ffb35540d25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "720fef6d9a046337810d4e59a17da200a58d1954471e9fd397c05ffb35540d25"
    sha256 cellar: :any_skip_relocation, sonoma:        "18304acbc03a2147aaeb0c43fb8365a6f2b63ab185ba77942ddffaf1c3821049"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "607e4c4519d00f97b5974cb005f7ce035620561b217fe096eb7ba7462c62d846"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0e4de7f7d8e965175c344ad7548626c7609df2d5d816e2148ff00ed203ca730"
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
