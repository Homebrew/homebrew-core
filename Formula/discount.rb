class Discount < Formula
  desc "C implementation of Markdown"
  homepage "https://www.pell.portland.or.us/~orc/Code/discount/"
  url "https://www.pell.portland.or.us/~orc/Code/discount/discount-2.2.6.tar.bz2"
  sha256 "ae68a4832ff8e620286304ec525c1fe8957be4d8f1e774588eb03d1c3deb74a7"

  bottle do
    cellar :any_skip_relocation
    sha256 "231a8ed8499ddec2aaad5731f273d84e5195a898f89fc7fc1548875c7fc7ddfe" => :catalina
    sha256 "579d7cf9a3930a8b91b748de259387554d28f900d7e3bedd310f64f8d5cb291e" => :mojave
    sha256 "c929af7cff8c87b6dcdf651009894659d3ca9ef7c21b1d935cf0889654b20a7b" => :high_sierra
  end

  conflicts_with "markdown", :because => "both install `markdown` binaries"
  conflicts_with "multimarkdown", :because => "both install `markdown` binaries"

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
