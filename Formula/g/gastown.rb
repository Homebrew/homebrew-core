class Gastown < Formula
  desc "Multi-agent workspace manager"
  homepage "https://github.com/steveyegge/gastown"
  url "https://github.com/steveyegge/gastown/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "d71eec68540f4b5724818f1b637a74fca9591e8407dbfeb56cf2572a98dbe910"
  license "MIT"
  head "https://github.com/steveyegge/gastown.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f98371d74148198c4792cc83a183d473abf727465eea04a035d2daa34075f88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f98371d74148198c4792cc83a183d473abf727465eea04a035d2daa34075f88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f98371d74148198c4792cc83a183d473abf727465eea04a035d2daa34075f88"
    sha256 cellar: :any_skip_relocation, sonoma:        "98bf190cc38e9b87e646ac8f3f8252c14e4758723cb9c22b8573abe28cf21845"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8168f0689e4d964e36921100efc66b63f0071e6e47bb0db0c8e5d8a801905c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dc248b0dedd609c05e8e92ded15c05ea62f508909c9eff29e934054727d689c"
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
