class Discount < Formula
  desc "C implementation of Markdown"
  homepage "https://www.pell.portland.or.us/~orc/Code/discount/"
  url "https://www.pell.portland.or.us/~orc/Code/discount/discount-2.2.4.tar.bz2"
  sha256 "74fd1e3cc2b4eacf7325d3fd89df38b589db60d5dd0f4f14a0115f7da5e230a5"

  bottle do
    cellar :any_skip_relocation
    sha256 "68cf5d30c76b372b89e9fa1ac9f4b30cf3f19592bbf257e1f792fc6afdc45bc1" => :high_sierra
    sha256 "b65dbaa7a1245f7f343707591630dae94449a8f979e766858550b4dbe2841c62" => :sierra
    sha256 "a8672b207a923a0b681e0abf20ce27b72421dd4c0ddd4fd816b1e63a2acd29c0" => :el_capitan
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
