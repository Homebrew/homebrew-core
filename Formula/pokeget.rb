# Github Link: https://github.com/talwat/pokeget
class Pokeget < Formula
  desc "Bash script that displays cool sprites of pokemon in your terminal"
  homepage "https://github.com/talwat/pokeget"
  url "https://github.com/talwat/pokeget/releases/download/1.4.3/pokeget_1.4.3-src.tar"
  sha256 "bcd94f2557856b47be7c338eddfdcc7a832f21545312a0432bb847a18b14b486"
  license "MIT"
  head "https://github.com/talwat/pokeget.git", branch: "main"

  depends_on "make" => :build
  on_macos do
    depends_on "coreutils"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/pokeget", "version"
  end
end
