class Discount < Formula
  desc "C implementation of Markdown"
  homepage "https://www.pell.portland.or.us/~orc/Code/discount/"
  url "https://www.pell.portland.or.us/~orc/Code/discount/discount-2.2.7.tar.bz2"
  sha256 "b1262be5d7b04f3c4e2cee3a0937369b12786af18f65f599f334eefbc0ee9508"
  license "BSD-3-Clause"
  head "https://github.com/Orc/discount.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "fbcfc1383e2818e7bf0231dcaf6a875ae3ec485ef0a98143567d3e7ed388f4f7" => :big_sur
    sha256 "231a8ed8499ddec2aaad5731f273d84e5195a898f89fc7fc1548875c7fc7ddfe" => :catalina
    sha256 "579d7cf9a3930a8b91b748de259387554d28f900d7e3bedd310f64f8d5cb291e" => :mojave
    sha256 "c929af7cff8c87b6dcdf651009894659d3ca9ef7c21b1d935cf0889654b20a7b" => :high_sierra
  end

  conflicts_with "markdown", because: "both install `markdown` binaries"
  conflicts_with "multimarkdown", because: "both install `markdown` binaries"

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --with-dl=Both
      --enable-dl-tag
      --enable-pandoc-header
      --enable-superscript
    ]
    system "./configure.sh", *args
    bin.mkpath
    lib.mkpath
    include.mkpath
    system "make", "install.everything"
  end

  test do
    markdown = "[Homebrew](https://brew.sh/)"
    html = "<p><a href=\"https://brew.sh/\">Homebrew</a></p>"
    assert_equal html, pipe_output(bin/"markdown", markdown, 0).chomp
  end
end
