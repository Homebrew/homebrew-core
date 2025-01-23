class Otf2bdf < Formula
  desc "OpenType to BDF font converter"
  homepage "https://github.com/jirutka/otf2bdf"
  url "https://slackware.uk/~urchlay/src/otf2bdf-3.1.tbz2"
  sha256 "3d63892e81187d5192edb96c0dc6efca2e59577f00e461c28503006681aa5a83"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia:  "5e44f2e2e203dd4d581516ddc4e6819fb99a8029356414019c63b7698910c3a2"
    sha256 cellar: :any,                 arm64_sonoma:   "d870da25b4ff6680200b767f9bd5c2d94bb4be4413498a4a80ea52d2af87aea1"
    sha256 cellar: :any,                 arm64_ventura:  "1ad51b1db3e7b521fb3608e43e27c495aae5438f03913f133b7ab14a85cd1ce6"
    sha256 cellar: :any,                 arm64_monterey: "6886123b0c45985af7cba20da8c3dad5b7781087f2ef1c7202eecb2d598c898f"
    sha256 cellar: :any,                 sonoma:         "1d140fa94e091509910ca6713ab82a97f7af120833ccc2e3978068be815f6fee"
    sha256 cellar: :any,                 ventura:        "edfb01b76f2db5887a66bdc3ecdc42081a03a4645a76fe6c15f626a7c6925129"
    sha256 cellar: :any,                 monterey:       "dafee8b4a63fb155ed161200df6c15e64ba054863cfcfc3171038b795bfc2ea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06814ebf37e5b3387409a79c416d52ab43c3a67d32ea1bea076d471bb0c84142"
  end

  depends_on "freetype"

  resource "test-font" do
    on_linux do
      url "https://raw.githubusercontent.com/paddykontschak/finder/master/fonts/LucidaGrande.ttc"
      sha256 "e188b3f32f5b2d15dbf01e9b4480fed899605e287516d7c0de6809d8e7368934"
    end
  end

  resource "mkinstalldirs" do
    url "https://raw.githubusercontent.com/jirutka/otf2bdf/master/mkinstalldirs"
    sha256 "e7b13759bd5caac0976facbd1672312fe624dd172bbfd989ffcc5918ab21bfc1"
  end

  def install
    buildpath.install resource("mkinstalldirs")
    chmod 0755, "mkinstalldirs"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    if OS.mac?
      assert_match "MacRoman", shell_output("#{bin}/otf2bdf -et /System/Library/Fonts/LucidaGrande.ttc")
    else
      resource("test-font").stage do
        assert_match "MacRoman", shell_output("#{bin}/otf2bdf -et LucidaGrande.ttc")
      end
    end
  end
end
