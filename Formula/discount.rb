class Discount < Formula
  desc "C implementation of Markdown"
  homepage "https://www.pell.portland.or.us/~orc/Code/discount/"
  url "https://www.pell.portland.or.us/~orc/Code/discount/discount-2.2.4.tar.bz2"
  sha256 "74fd1e3cc2b4eacf7325d3fd89df38b589db60d5dd0f4f14a0115f7da5e230a5"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0f5e9e6922a6bf89d1c62709016adb16009378041cba27697def862e44f5f14" => :mojave
    sha256 "d992c08149b8fc5ee583bfb78c3fa8dc16a6e036890353e6fb3ec18dcfdc25a0" => :high_sierra
    sha256 "727610146b825e993f7e03690394b9e6678afeefa25e16780e63a4522b43a3d6" => :sierra
    sha256 "80228f78ed111492fcad89a4739944cc43334b71d68b9550cc67f29ad894b560" => :el_capitan
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
    markdown = "[Homebrew](https://brew.sh/)"
    html = "<p><a href=\"https://brew.sh/\">Homebrew</a></p>"
    assert_equal html, pipe_output(bin/"markdown", markdown, 0).chomp
  end
end
