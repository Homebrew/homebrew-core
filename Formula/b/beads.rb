class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/gastownhall/beads"
  url "https://github.com/gastownhall/beads/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "ff97bd5320cb09613cccd77532eeaec29bdb0dc26af7bbbf2275913e97dbaada"
  license "MIT"
  compatibility_version 1
  head "https://github.com/gastownhall/beads.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "23bdff1e53de5d2045871c6cac48320ac5fdc81208eaa6838b1a6d29855fbe25"
    sha256 cellar: :any, arm64_tahoe:       "c6d643fdcbb9baab60762f4eff4cbf0fe1580a0d1be1f9a03cd313b4d12ca8e4"
    sha256 cellar: :any, arm64_sequoia:     "a7255b7cce406c4931fc4f2e2fe496f61ee64b9d50791df62c27c3e79c9a4f6f"
    sha256 cellar: :any, arm64_linux:       "083f6618c62c496d7e343333536ed021040fcf165e77a1ad563882a808f2626c"
    sha256 cellar: :any, x86_64_linux:      "363fc07e069cc526935d81cbb0ca4ac0b4db18bd4b6850ea6fe72108db234d28"
  end

  depends_on "go" => :build
  depends_on "dolt"
  depends_on "icu4c@79"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    if OS.linux? && Hardware::CPU.arm64?
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = %W[
      -X main.Version=#{version}
      -X main.Build=#{tap.user}
      -X main.Branch=#{build.head? ? "HEAD" : "v#{version}"}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/bd"
    bin.install_symlink "beads" => "bd"

    generate_completions_from_executable(bin/"bd", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bd --version")

    system bin/"bd", "init", "--prefix", "homebrew-beads", "--non-interactive", "--stealth"
    system bin/"bd", "setup", "claude"
    assert_path_exists testpath/"CLAUDE.md"
    assert_path_exists testpath/".beads/config.yaml"

    output = shell_output("#{bin}/bd --db #{testpath}/.beads/dolt info")
    assert_match "Beads Database Information", output
    assert_match "Issue Count: 0", output
  end
end
