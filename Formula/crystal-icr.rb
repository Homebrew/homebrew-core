class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/greyblake/crystal-icr"
  url "https://github.com/greyblake/crystal-icr/archive/v0.2.13.tar.gz"
  sha256 "33763fa190baad390df7143b437b1ddda3867a12ccf6e11c3278e53ecb94e40a"
  revision 1

  bottle do
    sha256 "41c369d2c4dc7b4572711cc24a0e04e1818452b4c744d6370456d1b89302c6b5" => :sierra
    sha256 "cc33f3a028bba2e5cd06fc1b0d37823b94c7a51bbcb3a5fa948cb0f90dbb4b4b" => :el_capitan
    sha256 "49968631daf1beff83c754af3c29e7b9941a2c18eaf24798317be7de69c4c92d" => :yosemite
  end

  depends_on "crystal-lang"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "icr version #{version}", shell_output("#{bin}/icr -v")
  end
end
