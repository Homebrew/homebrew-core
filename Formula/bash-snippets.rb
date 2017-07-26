class BashSnippets < Formula
  desc "Collection of small bash scripts for heavy terminal users"
  homepage "https://github.com/alexanderepstein/Bash-Snippets"
  url "https://github.com/alexanderepstein/Bash-Snippets/archive/v1.15.1.tar.gz"
  sha256 "5de784a2d81163329a4c931b3b8c739a89513a05690c1218816404c74270dea2"

  bottle :unneeded


  def install
    system "./install.sh", "--prefix=#{prefix}", "all"
  end

  test do
    system "#{bin}/crypt", "-h"
  end
end
