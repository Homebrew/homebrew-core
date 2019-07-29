class Markdown < Formula
  desc "Text-to-HTML conversion tool"
  homepage "https://daringfireball.net/projects/markdown/"
  url "https://daringfireball.net/projects/downloads/Markdown_1.0.1.zip"
  sha256 "6520e9b6a58c5555e381b6223d66feddee67f675ed312ec19e9cee1b92bc0137"

  bottle do
    cellar :any_skip_relocation
    sha256 "343d406a2a4838499afa96395733e0d61f91c725a4693e6c5b3c49293e5297e8" => :mojave
    sha256 "c7b43e96e9967731f9f9395152dca0d1535eb270a953aeccfe24dc99d3941f97" => :high_sierra
    sha256 "47715f7beb1f434a5d52e6977c7f6ad584be7b0d970dacb00ef5965bd162858d" => :sierra
    sha256 "a5b025bc09c8b274507cfc5c86da6350560477f24ce109dd5a79f2dafa97d805" => :el_capitan
    sha256 "5e1b8b5388f1b4ceefe3fae528ae83e2fa3f9ed9f27668e8faded36b9ec3274e" => :yosemite
    sha256 "66fffda1a29fd9e2dcddcb52fb9606f21d897bf4680583626b612a95d27b1e04" => :mavericks
  end

  conflicts_with "discount", :because => "both install `markdown` binaries"
  conflicts_with "multimarkdown", :because => "both install `markdown` binaries"

  def install
    bin.install "Markdown.pl" => "markdown"
  end

  test do
    assert_equal "<p>foo <em>bar</em></p>\n", pipe_output("#{bin}/markdown", "foo *bar*\n")
  end
end
