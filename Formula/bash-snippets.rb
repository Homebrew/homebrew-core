class BashSnippets < Formula
  desc "Collection of small bash scripts for heavy terminal users"
  homepage "https://github.com/alexanderepstein/Bash-Snippets"
  url "https://github.com/alexanderepstein/Bash-Snippets/archive/v1.15.0.tar.gz"
  sha256 "314e428aafcc4a02db57768a8fa65a384789af64339a919e73cba76a224a3caf"

  bottle :unneeded


  def install
    system "./install.sh", "--prefix=#{prefix}", "all"
  end

  test do
    system "#{bin}/crypt", "-h"
  end
end
