class Discount < Formula
  desc "C implementation of Markdown"
  homepage "https://www.pell.portland.or.us/~orc/Code/discount/"
  url "https://www.pell.portland.or.us/~orc/Code/discount/discount-2.2.4.tar.bz2"
  sha256 "74fd1e3cc2b4eacf7325d3fd89df38b589db60d5dd0f4f14a0115f7da5e230a5"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8f5a27a62f9a96cce7872780be458cf1cdee98333e4ff9ed4acd9772fd6bcd5f" => :catalina
    sha256 "717446676d0861c18c2cc4f7eb968eb8abec3c91bb623df176d1735d71ed58c3" => :mojave
    sha256 "fdcd1162af5608087a3520333760fb68a467866cf02ee059a876b38c0e684d5b" => :high_sierra
    sha256 "4798e5e4fb0dbcbcfe92babf8c0a9eb7d0739197a636f1daa34fd52715bba05d" => :sierra
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
