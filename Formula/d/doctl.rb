class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.115.0.tar.gz"
  sha256 "08c33702fa29d321b7ab005d16ddbc40d4acc6b0c1141080a127b820ae871156"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9192d752b3a2f754fdb044b62bc4a8c538c0338efff3d11471cef59c09b3b43d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9192d752b3a2f754fdb044b62bc4a8c538c0338efff3d11471cef59c09b3b43d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9192d752b3a2f754fdb044b62bc4a8c538c0338efff3d11471cef59c09b3b43d"
    sha256 cellar: :any_skip_relocation, sonoma:        "124d2cd4360c0184a3eebc3080e058038ea971b7d2710c996d29b2e06b6d4559"
    sha256 cellar: :any_skip_relocation, ventura:       "124d2cd4360c0184a3eebc3080e058038ea971b7d2710c996d29b2e06b6d4559"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f00ea0a6bdab755814aec14728854848816ecdd8a55a5f3a456fcab128cbc90"
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
