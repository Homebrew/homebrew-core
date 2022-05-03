class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.74.0.tar.gz"
  sha256 "3b0fcd2daff4cdce575f7a833a36c3a63a66c0dbb9af50baafe3ec9fe02c3872"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a6719230266ceffeb9b9596bb67b8a26172e0f62094ea04a3c068160c92ac73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ef58a4a751fb9084fe20bad7b1a30e14a0f4d3f9cb643a22910b600bf9830a0"
    sha256 cellar: :any_skip_relocation, monterey:       "b2e68eaf17606766658817e87042f0d863c8e89959ca9196dc3cb1da95fa92d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "a82a3f3c8d5b12b3e250fac4dd743cca6eabd1bcafd5014d794cbbc0f309f3ee"
    sha256 cellar: :any_skip_relocation, catalina:       "4bb21c70d8b7c04b150c8a22aba7c2ff0864462fdabc80a9d8247fbe22dc4c02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae87ed8f6d21352e149b22420b60898bb9d1b72484ef1529028719b2c765157d"
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

    (bash_completion/"doctl").write `#{bin}/doctl completion bash`
    (zsh_completion/"_doctl").write `#{bin}/doctl completion zsh`
    (fish_completion/"doctl.fish").write `#{bin}/doctl completion fish`
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
