class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://github.com/steveyegge/beads/archive/refs/tags/v0.49.2.tar.gz"
  sha256 "0ba23a5c45f6870c25eb4952523d6fbf2a9606cd89640fd5dada10f9dac00fc8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d05d40813089f84bb2a5c6a5671c387a6ba2b7840350c97a404d826cb30bc2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c8624e79599918c3c5e003f632ce6890b12e970df504101144ea13fbaf36dd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d5141b8c2ee820d5cb800826416f108d061e2acf59423e3456aa0e9b5e2fef2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a182ae4d9aa233523b0a55aab84d5f8078ce26d0a88b4cd3058feeb4fd0d4fd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcbf2aee13ca2a058eb196b9a899cf7db4df54efebdb359b1b002256231d86f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99b5cb7497f523a37e18406715c849ac31bc20b43ce0ff4791c23fce6d6b524d"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Build=#{tap.user}
      -X main.Commit=#{tap.user}
      -X main.Branch=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/bd"
    bin.install_symlink "beads" => "bd"

    generate_completions_from_executable(bin/"bd", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bd --version")

    system "git", "init"

    system bin/"bd", "init"
    assert_path_exists testpath/"AGENTS.md"

    output = shell_output("#{bin}/bd info")
    assert_match "Connected: yes", output
  end
end
