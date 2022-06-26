class Markdown < Formula
  desc "Text-to-HTML conversion tool"
  homepage "https://daringfireball.net/projects/markdown/"
  url "https://daringfireball.net/projects/downloads/Markdown_1.0.1.zip"
  sha256 "6520e9b6a58c5555e381b6223d66feddee67f675ed312ec19e9cee1b92bc0137"

  livecheck do
    url :homepage
    regex(/href=.*?Markdown[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "67c32d524f9f8e4c364f2b703192165d21ab5317afe23bf9a57dc8428329ea61"
    sha256 cellar: :any_skip_relocation, big_sur:       "07611f1e774c865bfcd44ae2f153aff4f43a0c29dc848f30aeb1b117ae04a4a9"
    sha256 cellar: :any_skip_relocation, catalina:      "35864422386d1390de813462b697b604813bc3a7caac7bf3fd172335e25b2a55"
    sha256 cellar: :any_skip_relocation, mojave:        "343d406a2a4838499afa96395733e0d61f91c725a4693e6c5b3c49293e5297e8"
    sha256 cellar: :any_skip_relocation, high_sierra:   "c7b43e96e9967731f9f9395152dca0d1535eb270a953aeccfe24dc99d3941f97"
    sha256 cellar: :any_skip_relocation, sierra:        "47715f7beb1f434a5d52e6977c7f6ad584be7b0d970dacb00ef5965bd162858d"
    sha256 cellar: :any_skip_relocation, el_capitan:    "a5b025bc09c8b274507cfc5c86da6350560477f24ce109dd5a79f2dafa97d805"
    sha256 cellar: :any_skip_relocation, yosemite:      "5e1b8b5388f1b4ceefe3fae528ae83e2fa3f9ed9f27668e8faded36b9ec3274e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81a249345ca5c8dac30337b38257abfe4e5479f8174998ac6cf3dee9dfab4a9d"
    sha256 cellar: :any_skip_relocation, all:           "81a249345ca5c8dac30337b38257abfe4e5479f8174998ac6cf3dee9dfab4a9d"
  end

  conflicts_with "discount", because: "both install `markdown` binaries"
  conflicts_with "multimarkdown", because: "both install `markdown` binaries"

  def install
    bin.install "Markdown.pl" => "markdown"
  end

  test do
    assert_equal "<p>foo <em>bar</em></p>\n", pipe_output("#{bin}/markdown", "foo *bar*\n")
  end
end
