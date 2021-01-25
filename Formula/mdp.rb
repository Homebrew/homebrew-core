class Mdp < Formula
  desc "Command-line based markdown presentation tool"
  homepage "https://github.com/visit1985/mdp"
  url "https://github.com/visit1985/mdp/archive/1.0.15.tar.gz"
  sha256 "3edc8ea1551fdf290d6bba721105e2e2c23964070ac18c13b4b8d959cdf6116f"
  license "GPL-3.0"
  head "https://github.com/visit1985/mdp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "422a1aa5fdbc6c1286036480a306c5842876a26982d78809b3ad84c448971018" => :big_sur
    sha256 "4807986d02b7d09a0bcdd726ab3efd74434a2a2a298a0e4db4f88301f0c5c5be" => :arm64_big_sur
    sha256 "4d4430aea06ed48c1284b8a6b064d2e69a8a37cafb27de9ad5c65ce08c4681c4" => :catalina
    sha256 "606ffc22ff72a524f46ae683466098409e2db33cb5de58dad6ea179a9390cdbc" => :mojave
    sha256 "0bfa062ad64e8da4fa6d1df9be7e8a52da7799f87fc012b80847ac58adf81830" => :high_sierra
    sha256 "b38a74964fd0ac22fcbb50eb569b165128799f77a32d582f102278252b6bd291" => :sierra
  end

  uses_from_macos "ncurses"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "sample.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdp -v")
  end
end
