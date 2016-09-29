# jless (Jam Less) is Japan-ized Less.
# jless supports ISO 2022 code extension techniques and Japanese codes.
class Jless < Formula
  desc "File pager supporting ISO2022"
  homepage "http://www.greenwoodsoftware.com/less/"
  url "http://www.greenwoodsoftware.com/less/less-481.tar.gz"
  sha256 "3fa38f2cf5e9e040bb44fffaa6c76a84506e379e47f5a04686ab78102090dda5"
  version_scheme 1

  bottle do
    revision 1
    sha256 "00d5e6a985a6692c51f9c3b81e9ab954a2a2e8adc75861423e7830c6d46575d8" => :el_capitan
    sha256 "a7a470e7de19322dd2d4fb3e8b2be38cbc340936771aa00864a800f79e107b54" => :yosemite
    sha256 "614093a58873090cc70f51e5e0ff0fb7b3ee76214c619879258679502c9ee750" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install", "binprefix=j", "manprefix=j"
  end

  def caveats
    "You may need to set the environment variable 'JLESSCHARSET' to japanese-utf8"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jless --version")
  end
end
