class BashSnippets < Formula
  desc "Collection of small bash scripts for heavy terminal users"
  homepage "https://github.com/alexanderepstein/Bash-Snippets"
  url "https://github.com/alexanderepstein/Bash-Snippets/archive/v1.15.1.tar.gz"
  sha256 "10246a24df02365527e654f27897d8dd36abd151e1b1bb6aaa5a0b3e2cab5496"

  bottle :unneeded


  def install
    system "./install.sh", "--prefix=#{prefix}", "all"
  end

  test do
    system "#{bin}/crypt", "-h"
  end
end
