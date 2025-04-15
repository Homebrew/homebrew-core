class Krep < Formula
  desc "High-Performance String Search Utility"
  # upstream project page bug report, https://github.com/davidesantangelo/krep/issues/19
  homepage "https://github.com/davidesantangelo/krep"
  url "https://github.com/davidesantangelo/krep/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "434003eb3e969a61dafd37fd146c5a7261dbedfda7eb50a11df5b466dc324f48"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "549120f44c011ba1f3ebf93a29b6229e8cfaa97bb0736fbe378b312561cebc76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2e536cf253e35b71ef1a1c7d7ac20385a5172b7aaac000191afbf3a209c1716"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5f094c14af723fde86165a8aedea58a49331933152dfb8e73a02a5daebb5048"
    sha256 cellar: :any_skip_relocation, sonoma:        "a86a5c6462359fea2f095b3d9234a8d1115dc73f0665f644fdd09d7e4727be39"
    sha256 cellar: :any_skip_relocation, ventura:       "9e6727d44fe10d4faaab88e6a52fcc881ee1715dabf9d0f76743ed93ed22ada9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05fc4246fb5bb2f5a8b06739290370dc3116ce0d1c47badced37895290e774c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d54f296395b2fc3eb7ebb2bbc4f6c343e04d53703e3d1a6272e5ced1e1b9c5aa"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/krep -v")

    text_file = testpath/"file.txt"
    text_file.write "This should result in one match"

    output = shell_output("#{bin}/krep -c 'match' #{text_file}").strip
    assert_match "1", output
  end
end
