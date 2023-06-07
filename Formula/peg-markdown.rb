class PegMarkdown < Formula
  desc "Markdown implementation based on a PEG grammar"
  homepage "https://github.com/jgm/peg-markdown"
  url "https://github.com/jgm/peg-markdown/archive/0.4.14.tar.gz"
  sha256 "111bc56058cfed11890af11bec7419e2f7ccec6b399bf05f8c55dae0a1712980"
  license any_of: ["GPL-2.0-or-later", "MIT"]
  revision 1
  head "https://github.com/jgm/peg-markdown.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b86b3203ed481c4afb9bcbd489a4803b3f1fd204c27bbed16dc42e45e16790fb"
    sha256 cellar: :any,                 arm64_monterey: "93a7ee730c2fb9c01ab25be02028ff8b25907d2a1693de10f07864b861f3be13"
    sha256 cellar: :any,                 arm64_big_sur:  "25d1eb833b0688d0b2db0667f105d27e50d6a46a14ea57be5aa5ef50c7127f62"
    sha256 cellar: :any,                 ventura:        "9a7b88b03ac9871d36d6072135cddb6fce38933ffbbf6836a6a9d9265bc0aaa2"
    sha256 cellar: :any,                 monterey:       "9f10d8b70ae2e5fc012c2baf976a2235c9501be317dde74b17648052dd801388"
    sha256 cellar: :any,                 big_sur:        "efefd2a49548d4abdfc97bdc12295b1f6dac5b1832f21d9b6f147cc7a3c27176"
    sha256 cellar: :any,                 catalina:       "08910e3fdd97183865c2839a4e14839826101e6dfa48120aebc60fbe838f0689"
    sha256 cellar: :any,                 mojave:         "a60087175a8f3c5242e9183eeddb433e6bdbe68409cae0a7c61d66da4622b150"
    sha256 cellar: :any,                 high_sierra:    "207764b26b253904cf61e9e13eb32e81a51d61d548b7dafd366da5a5394a5f08"
    sha256 cellar: :any,                 sierra:         "2d75448f008aa176b624ecb02bc6e3f7492ea8953a99f84fcdacc6b301b39412"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1b2212c3e3a3610a02a5f668e3b88785c0bf1c6383f36ed3674abe42cc941bc"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "make"
    bin.install "markdown" => "peg-markdown"
  end

  test do
    assert_equal "<p><strong>Homebrew</strong></p>",
      pipe_output("#{bin}/peg-markdown", "**Homebrew**", 0).chomp
  end
end
