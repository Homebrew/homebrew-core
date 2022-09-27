class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.82.0.tar.gz"
  sha256 "d555d5fe417fce0850cff7fdbb87259f8a14dc7fb2ff56746bef8fcdd746d949"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96a325c10492332d27bc479c26836ff261d32ab6fd1b228c8b7d46eedc2aa630"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7eda992bc9bcbd13daa3289ab8d8efac7ad98a8b9607aeca27dbf3b4c8d3ed0"
    sha256 cellar: :any_skip_relocation, monterey:       "3007ef34cf10211ee24a96d632b79490415361eb5570feb23dec8606120fdbc1"
    sha256 cellar: :any_skip_relocation, big_sur:        "380f0fdf064f021d5a55bc00ba5d645460d541240a70e41c32bd8fd5998c8590"
    sha256 cellar: :any_skip_relocation, catalina:       "72365a496b12b1c8bc51ece6e48fb1b901f2324e848785515584cc39b8051a46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c055ba0cd03d971425fc04cff8072cb50bac569ebe5527a2558d9c96bfe7ed14"
  end

  depends_on "go" => :build

  def install
    base_flag = "-X github.com/digitalocean/doctl"
    ldflags = %W[
      #{base_flag}.Major=#{version.major}
      #{base_flag}.Minor=#{version.minor}
      #{base_flag}.Patch=#{version.patch}
      #{base_flag}.Label=release
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/doctl"

    generate_completions_from_executable(bin/"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
