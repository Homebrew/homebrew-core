class GoMd2man < Formula
  desc "Converts markdown into roff (man pages)"
  homepage "https://github.com/cpuguy83/go-md2man"
  url "https://github.com/cpuguy83/go-md2man.git",
      tag:      "v2.0.2",
      revision: "d97078115282836e16d0dca10b4b42ce60fc70e6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "501d739e8eee89129cf4723552580065dcfe087a71d2674b5df8a643394a6ed4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c90b9a66b208691bd21aac4d739b2a55abdb2b328a858fbcbc161b7e9fe6257"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c90b9a66b208691bd21aac4d739b2a55abdb2b328a858fbcbc161b7e9fe6257"
    sha256 cellar: :any_skip_relocation, ventura:        "b8870d7145f1b804f1aa7426053a1d8230e669e929468044aea807e99a908a9d"
    sha256 cellar: :any_skip_relocation, monterey:       "bf229a23b6bfe77c80872668ccaa52da73fba7b3dcce34085661dbecb5bb9f75"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf229a23b6bfe77c80872668ccaa52da73fba7b3dcce34085661dbecb5bb9f75"
    sha256 cellar: :any_skip_relocation, catalina:       "bf229a23b6bfe77c80872668ccaa52da73fba7b3dcce34085661dbecb5bb9f75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b64c10c08f4f0d6c663beedba7a143c448950c5bab845a8b1099d3f20bc38d4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    system bin/"go-md2man", "-in=go-md2man.1.md", "-out=go-md2man.1"
    man1.install "go-md2man.1"
  end

  test do
    assert_includes pipe_output(bin/"go-md2man", "# manpage\nand a half\n"),
                    ".TH manpage\n.PP\nand a half\n"
  end
end
