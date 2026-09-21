class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.22.7.tar.gz"
  sha256 "220d0d58db0a46d8676cc4972149789899c1e68386a5260b08e135622921d7bf"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "28fd7573fa265f1630f999b3be7ad16b4c3de4c4b6858e22616b090eb3ea6efa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e5209c50469da2e6e83bd83411528f24984cc95fdd297eb05f4e686233bec6a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "25cd8aefd060f7e6c8ef5b820186b99ed8bdafed389b6b4344f001be86ef6570"
    sha256 cellar: :any,                 arm64_linux:       "0bbb1af8d6ff35b461608eb349d4958e26950aa9471d596dffdf16f38d974e47"
    sha256 cellar: :any,                 x86_64_linux:      "d73ccbdbbf3771580840620db5cb9dba0bd39db88652fa91e16dc7f9b03d1256"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", *std_cargo_args(features: "binjulialauncher")
    system "cargo", "install", *std_cargo_args(path: "juliaupgui")

    bin.install_symlink "julialauncher" => "julia"

    generate_completions_from_executable(bin/"juliaup", "completions")
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
    assert_path_exists bin/"juliaupgui"
  end
end
