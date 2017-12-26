class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/crystal-community/icr"
  url "https://github.com/crystal-community/icr/archive/v0.4.0.tar.gz"
  sha256 "6d3ba783b68a425c3def6918bbfb48c828d0d56e8636b7afbebd12a40a7dc5d3"
  revision 1

  bottle do
    sha256 "08ae4625fa25214c13ebf03dbe2db9110f1298b2ff9023b9f4bcc1ad32b538fa" => :high_sierra
    sha256 "3f315d6471eafd01ae864a937233e6617115ae8fe9e971a7b3247b88a06f4a99" => :sierra
    sha256 "c36b7478e32bf42a8d3d528c7f267c366cc03bdd05af692eaf1ad15389e6a8f8" => :el_capitan
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
