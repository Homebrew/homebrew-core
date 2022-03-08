class Gemgen < Formula
  desc "Command-line tool for converting Commonmark Markdown to Gemtext"
  homepage "https://sr.ht/~kota/gemgen/"
  url "https://git.sr.ht/~kota/gemgen/archive/v0.6.0.tar.gz"
  sha256 "ea0ab8fb45d8b2aa89bb3d5fd4e3ccf559dc509be6bf4c2a2cbaa95d1f69dc22"
  license "GPL-3.0-or-later"
  head "https://git.sr.ht/~kota/gemgen", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "784c371394fa6476daea9391ef69a942f02e0a7086cf0daaeacea8ceaca8eae4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c36ace2b3b409206241e66b32567762ab6c448d89a8e050cf26f419f5ef0bd6"
    sha256 cellar: :any_skip_relocation, monterey:       "8fd891edc0e50292ca76deb0a63696d1c06b231cebaa067e99ce99bad886c96c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f780a553c7050f67c43216d76d06d041d3a341bf5cc67a2072810c912ae6a96"
    sha256 cellar: :any_skip_relocation, catalina:       "0857a312379268423766b69c2874172e716a92c22d6e63d3ce7fa6430c06a9b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb58367b892d290ae3a9801e4e297413cda4b890183de712db3b1f635a04e646"
  end

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
