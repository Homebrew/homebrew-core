class Nvimpager < Formula
  desc "Use NeoVim as a pager to view manpages, diffs, etc."
  homepage "https://github.com/lucc/nvimpager"
  url "https://github.com/lucc/nvimpager/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "001c49098690e4baa6857557b9edc564433825a1947ec368a1e52d63aa1715a3"
  license "BSD-2-Clause"
  head "https://github.com/lucc/nvimpager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "32a91a8517cf1e7653aae356da102e227e4507166e77e14bf06d7071de612998"
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
