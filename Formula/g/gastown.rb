class Gastown < Formula
  desc "Multi-agent workspace manager"
  homepage "https://github.com/steveyegge/gastown"
  url "https://github.com/steveyegge/gastown/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "ddfaf8e774e9f3a281239c04592d04aee10afe621cbfa5df3e29310c9838d753"
  license "MIT"
  head "https://github.com/steveyegge/gastown.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d22e1b8dfd9ddc572dc95278f322f58440873e0489b412f028b9d9c595f2cbd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d22e1b8dfd9ddc572dc95278f322f58440873e0489b412f028b9d9c595f2cbd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d22e1b8dfd9ddc572dc95278f322f58440873e0489b412f028b9d9c595f2cbd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "43185d214231cb9b775e2c4931c2a9614561b5e6fd432f582720fb6a6df2d1d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "361f7e4997fb48a94df7af73132ba5af3c69b13f0ccc66d7da995ce6defcf26f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65c96bcb23693122ac7327608779305c37f9978cf4530e060807bb4209e85932"
  end

  depends_on "go" => :build
  depends_on "beads"
  depends_on "icu4c@78"

  conflicts_with "genometools", "libslax", because: "both install `gt` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/steveyegge/gastown/internal/cmd.Version=#{version}
      -X github.com/steveyegge/gastown/internal/cmd.Build=#{tap.user}
      -X github.com/steveyegge/gastown/internal/cmd.Commit=#{tap.user}
      -X github.com/steveyegge/gastown/internal/cmd.Branch=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/gt"
    bin.install_symlink "gastown" => "gt"

    generate_completions_from_executable(bin/"gt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gt version")

    system "dolt", "config", "--global", "--add", "user.name", "BrewTestBot"
    system "dolt", "config", "--global", "--add", "user.email", "BrewTestBot@test.com"

    system bin/"gt", "install"
    assert_path_exists testpath/"mayor"
  end
end
