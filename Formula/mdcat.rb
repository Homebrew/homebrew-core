class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://codeberg.org/flausch/mdcat"
  url "https://codeberg.org/flausch/mdcat/archive/mdcat-0.26.1.tar.gz"
  sha256 "1120c4f3b5b517075b6347dbfe76a2211a91837b4d0242c0b72cdbc19e6886dd"
  license "MPL-2.0"
  head "https://codeberg.org/flausch/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12f57010161981a444c3026977e1eebeda9f3719e85d8036eb3c01426055fe6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10f6d24300205f1d513976d8abe7a7dfe1efd045383956fca7c19272ca9896b2"
    sha256 cellar: :any_skip_relocation, monterey:       "b2dfb2acadf101ca418cc96a2f3de30ac03fab1b7d7977f47e13e880cdb5cc9f"
    sha256 cellar: :any_skip_relocation, big_sur:        "2dacdc8793ee6cedc0fa76db28153fb57c27ba42260714d3fcbec84fdad800d3"
    sha256 cellar: :any_skip_relocation, catalina:       "9ab6093b76b7903b60780ad348a4780087ca5cdc19052e851a198e8920f413da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9fdbe394e6c5ba0e940d52ed35aeea543ba679b20bb577a75f825d549280890"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
