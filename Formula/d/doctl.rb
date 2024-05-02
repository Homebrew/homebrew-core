class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.105.0.tar.gz"
  sha256 "75a7a4854f9607f1e1fcaf3571232c8733f754a428a779be687f41dafba43679"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2fd2fac0d675100e2911a542e0716a650f56b8420c553af6a43682eaa304cfe4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00b45036584d49d2b7ead96abce485b57c29a825d8dc16dec21db49d3a1d625e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "712bf140213dc850cce97b593fe93c7c8c7666e1e2c0141e98a1bf8aa5e96539"
    sha256 cellar: :any_skip_relocation, sonoma:         "db27294f203c69a9da5ca4e09e65a8a39000d496c1f66e448477872130c554a8"
    sha256 cellar: :any_skip_relocation, ventura:        "03e0a7826a55102b38d1cd3d9f2ca80bd8acd530fcf64190a7c41ada3b2c58ea"
    sha256 cellar: :any_skip_relocation, monterey:       "ec02c69cd6b949c6c06e06d6211d8807b723ea813a7e39eaf0241055cf823368"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86d76707126ae964d0f5461405572d0f21fa41aa24ab7dc9b16130cf0666f704"
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

    system "go", "build", *std_go_args(ldflags:), "./cmd/doctl"

    generate_completions_from_executable(bin/"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
