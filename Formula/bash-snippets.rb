class BashSnippets < Formula
  desc "Collection of small bash scripts for heavy terminal users"
  homepage "https://github.com/alexanderepstein/Bash-Snippets"
  url "https://github.com/alexanderepstein/Bash-Snippets/archive/v1.15.1.tar.gz"
  sha256 "ecc771d8d8486229309bdcaef330492ce37fb827e6ce276f251380db4a63930b"

  bottle :unneeded


  def install
    system "./install.sh", "--prefix=#{prefix}", "all"
  end

  test do
    system "#{bin}/crypt", "-h"
  end
end
