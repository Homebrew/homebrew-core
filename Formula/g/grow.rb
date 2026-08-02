# Upstream (Homebrew/homebrew-core) formula variant for Grow.
#
# Differs from packaging/harmonybrew/grow.rb (the OpenHarmony port):
#   - default features ON (jemalloc + sandbox-enforce, matching the official
#     release builds); only distro-pm is added to disable self-update
#   - no `depends_on "zsh"`: macOS ships zsh, Linux falls back to bash
# The source tarball carries the vendored crates (third_party/nix-ohos etc.);
# their patches are behavior-neutral on macOS/Linux and exist for the
# OpenHarmony target (Harmonybrew port), which upstream cannot build.
class Grow < Formula
  desc "Terminal-based AI coding agent with a Rust TUI (fork of xAI Grok Build)"
  homepage "https://github.com/LordCasser/grow"
  url "https://github.com/LordCasser/grow/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "2bbc6fada4bfa1bcc5eaaaa7bee6b791ff044703752101b77c2fb2e658961dd7"
  license "Apache-2.0"
  head "https://github.com/LordCasser/grow.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "rust" => :build
  depends_on "ripgrep"

  def install
    # distro-pm disables self-update: the package manager owns upgrades.
    system "cargo", "install", *std_cargo_args(path: "crates/codegen/cli"), "--bin", "grow",
           "--features", "distro-pm"
  end

  test do
    assert_match "grow", shell_output("#{bin}/grow --version")
  end
end
