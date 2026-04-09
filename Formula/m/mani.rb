class Mani < Formula
  desc "CLI tool to help you manage repositories"
  homepage "https://manicli.com"
  url "https://github.com/alajmo/mani/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "63151cc156130b335b1f844c6e88049670647c44d4a42516510a9fd70edff9b0"
  license "MIT"
  head "https://github.com/alajmo/mani.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fd99addf4ca0ecc539b7b2e55ed95cca0e0c9aea8f7edb7814d2ed964a51602"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fd99addf4ca0ecc539b7b2e55ed95cca0e0c9aea8f7edb7814d2ed964a51602"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fd99addf4ca0ecc539b7b2e55ed95cca0e0c9aea8f7edb7814d2ed964a51602"
    sha256 cellar: :any_skip_relocation, sonoma:        "27be6de31d5b65fc29273df8968b5bb60d9a3979ad2d4f490576d824310a38b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0ba27a8d4b80afc88021e279a24bc1c5684611e3d920d20eba9a8101dcafd45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae938083622d72bb131aa2210a0568e0a5a2a60527469e41080866040f85cce1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alajmo/mani/cmd.version=#{version}
      -X github.com/alajmo/mani/core/tui.version=#{version}
      -X github.com/alajmo/mani/cmd.commit=#{tap.user}
      -X github.com/alajmo/mani/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "netgo")
    generate_completions_from_executable(bin/"mani", shell_parameter_format: :cobra)
    system bin/"mani", "gen"
    man1.install "mani.1"
  end

  test do
    assert_match "Version: #{version}", shell_output("#{bin}/mani --version")

    (testpath/"mani.yaml").write <<~YAML
      projects:
        mani:
          url: https://github.com/alajmo/mani.git
          desc: CLI tool to help you manage repositories
          tags: [cli, git]

      tasks:
        git-status:
          desc: Show working tree status
          cmd: git status
    YAML

    system bin/"mani", "sync"
    assert_match "On branch main", shell_output("#{bin}/mani run git-status --tags cli")
  end
end
