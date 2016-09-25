class Discount < Formula
  desc "C implementation of Markdown"
  homepage "http://www.pell.portland.or.us/~orc/Code/discount/"
  url "http://www.pell.portland.or.us/~orc/Code/discount/discount-2.2.1.tar.bz2"
  sha256 "88458c7c2cfc870f8e6cf42b300408c112e05a45c88f8af35abb33de0e96fe0e"

  bottle do
    cellar :any_skip_relocation
    sha256 "a20f4d6f1b8f548432100c6cb6eb18eec06e5fcba34e0622a243a1332559e64e" => :sierra
    sha256 "4e249da5268aafc6481a20e843dcb8bfb4ea467acf78596a23c70e8fd9ff07ed" => :el_capitan
    sha256 "b750ab251006f3ac79144586643c035e6fe36e5e6ef8c80c1a912c685c4ab28b" => :yosemite
  end

  option "with-fenced-code", "Enable Pandoc-style fenced code blocks."
  option "with-shared", "Install shared library"

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
    args << "--with-fenced-code" if build.with? "fenced-code"
    args << "--shared" if build.with? "shared"
    system "./configure.sh", *args
    bin.mkpath
    lib.mkpath
    include.mkpath
    system "make", "install.everything"
  end

  test do
    markdown = "[Homebrew](http://brew.sh)"
    html = "<p><a href=\"http://brew.sh\">Homebrew</a></p>"
    assert_equal html, pipe_output(bin/"markdown", markdown, 0).chomp
  end
end
