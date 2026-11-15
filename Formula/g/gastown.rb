class Gastown < Formula
  desc "Multi-agent workspace manager"
  homepage "https://github.com/gastownhall/gastown"
  url "https://github.com/gastownhall/gastown/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "ddfaf8e774e9f3a281239c04592d04aee10afe621cbfa5df3e29310c9838d753"
  license "MIT"
  revision 1
  head "https://github.com/gastownhall/gastown.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "16569af307eb9f748826dc349752cbdf1af973d165cdbc3bea6a9f3c97229f07"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "16569af307eb9f748826dc349752cbdf1af973d165cdbc3bea6a9f3c97229f07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "16569af307eb9f748826dc349752cbdf1af973d165cdbc3bea6a9f3c97229f07"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2f228cd4bcf6538fc2763dcf93dcfd19954d5a6e569fa909bb3eee6a38a0f79f"
    sha256 cellar: :any,                 x86_64_linux:      "ba271ecd30c05d75634e1abfa64034877dceec64197c947cc259b291b05d0af0"
  end

  depends_on "go" => :build
  depends_on "beads"
  depends_on "icu4c@79"

  conflicts_with "genometools", "libslax", because: "both install `gt` binaries"

  # Test binds a local port
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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

    system bin/"gt", "install", "--dolt-port", free_port.to_s
    assert_path_exists testpath/"mayor"
  end
end
