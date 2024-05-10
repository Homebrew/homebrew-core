class Nvimpager < Formula
  desc "Use NeoVim as a pager to view manpages, diffs, etc."
  homepage "https://github.com/lucc/nvimpager"
  url "https://github.com/lucc/nvimpager.git",
      tag:      "v0.12.0",
      revision: "72639e94e739c7c0948043ec8f8bf38ea222d0a9"
  license "BSD-2-Clause"
  head "https://github.com/lucc/nvimpager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "323b753e500c077e90388c784d2be86b63cf7fdc26874931df283712dcd1cc97"
  end

  depends_on "scdoc" => :build
  depends_on "neovim"

  uses_from_macos "bash"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  def caveats
    <<~EOS
      To use nvimpager as your default pager, add `export PAGER=nvimpager`
      to your shell configuration.
    EOS
  end

  test do
    (testpath/"test.txt").write <<~EOS
      This is test
    EOS

    assert_match(/This is test/, shell_output("#{bin}/nvimpager test.txt"))
  end
end
