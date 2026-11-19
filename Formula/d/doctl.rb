class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "6c5562320fa40457c858393bd305ba1ae60a538c3f89264b82af65f6072fd212"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2f03eb18b28234b60870cd20d380e74a1509e54e977153e58a9e223235149467"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2f03eb18b28234b60870cd20d380e74a1509e54e977153e58a9e223235149467"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2f03eb18b28234b60870cd20d380e74a1509e54e977153e58a9e223235149467"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "386907b856127f97166bef6613df27b27cb84b1011b0709cb253a7c79ae5bdf5"
    sha256 cellar: :any,                 x86_64_linux:      "4647d955c6543f4a6426420bdb641fff81c8b1569122bd46c9f25bc5b96ef9a2"
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
