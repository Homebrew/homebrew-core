class Gemgen < Formula
  desc "Command-line tool for converting Commonmark Markdown to Gemtext"
  homepage "https://sr.ht/~kota/gemgen/"
  url "https://git.sr.ht/~kota/gemgen/archive/v0.6.0.tar.gz"
  sha256 "ea0ab8fb45d8b2aa89bb3d5fd4e3ccf559dc509be6bf4c2a2cbaa95d1f69dc22"
  license "GPL-3.0-or-later"
  head "https://git.sr.ht/~kota/gemgen", branch: "master"

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    input = testpath/"test.md"
    input.write <<~EOF
      # Typeface

      A typeface is the design of [lettering](https://en.wikipedia.org/wiki/Lettering)
      that can include variations in size, weight (e.g. bold), slope (e.g. italic),
      width (e.g. condensed), and so on. Each of these variations of the typeface is a
      font.

      ## Popular Fonts

      [DejaVu](https://dejavu-fonts.github.io/)\
      [EB Garamond](https://github.com/octaviopardo/EBGaramond12)
    EOF
    system "gemgen", "-o", testpath, input
    output = <<~EOF
      # Typeface

      A typeface is the design of lettering that can include variations in size, weight (e.g. bold), slope (e.g. italic), width (e.g. condensed), and so on. Each of these variations of the typeface is a font.

      => https://en.wikipedia.org/wiki/Lettering lettering

      ## Popular Fonts

      => https://dejavu-fonts.github.io/ DejaVu
      => https://github.com/octaviopardo/EBGaramond12 EB Garamond

    EOF
    assert_equal output, (testpath/"test.gmi").read
  end
end
