class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/crystal-community/icr"
  url "https://github.com/crystal-community/icr/archive/v0.2.14.tar.gz"
  sha256 "0f8cb18d04cc1e0247586d66fad904d56c29658edfb04b0091c464864f2cdbdf"
  revision 2

  bottle do
    sha256 "951ce7170516e7b5b5adc4b64f52b4053ad36ce581e2dbc43843f0e07ea2eedf" => :sierra
    sha256 "b6677ec4428770723ebee3a5059eee7a5a9a37b01943e09cce0654f7f6c58bac" => :el_capitan
    sha256 "bc7b3b94b127632b60dd14127749d16ef92ba97520163226e1a0ccf0910a5579" => :yosemite
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
