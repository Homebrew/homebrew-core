class Nkt < Formula
  desc "TUI for fast and simple interacting with your BibLaTeX database"
  homepage "https://git.sr.ht/~fjebaker/nkt"
  url "https://git.sr.ht/~fjebaker/nkt/archive/0.3.1.tar.gz"
  sha256 "cfcede02c12cfe2fca4465fa3d87c03158202e4606c1ba3db46851dbb0451ccd"
  license "GPL-3.0-or-later"
  head "https://git.sr.ht/~fjebaker/nkt", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d86080df616f5dcad2cc5ce9599ecbc5fdbfb80a8db24a3de0bdf050ef35c8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a630b18e8691b0dd606ddca5b04429006ec27b116f18c3a809f9cce2d74aee56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27ba7b993d15698705afb765ed031dc1f25a48741a9b527f9d8ad6087cb0f150"
    sha256 cellar: :any_skip_relocation, sonoma:        "40ddc496b017d3132c6cd4a57d4a75e80fcc4f1b97c61367a8c3f6c72034c0dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c448f427484730ca96a5baffedd2be5c72fe384ce13a07012589ad5a0dbe61fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bfad96393a8777fd9c745d034c8baf253c1a1a62c393f0a6322b3190bd9be07"
  end

  depends_on "zig" => :build

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case ENV.effective_arch
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else ENV.effective_arch
    end

    args = []
    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *std_zig_args, *args
  end

  test do
    system bin/"nkt", "init"
    assert_path_exists testpath/".nkt"

    system bin/"nkt", "log", "this is my first diary entry"

    system bin/"nkt", "task", "learn more about that thing", "--due", "monday"
    assert_match "learn more about that thing", (testpath/".nkt/tasklists/todo.json").read
  end
end
