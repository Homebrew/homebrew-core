class Discount < Formula
  desc "C implementation of Markdown"
  homepage "http://www.pell.portland.or.us/~orc/Code/discount/"
  url "http://www.pell.portland.or.us/~orc/Code/discount/discount-2.2.2.tar.bz2"
  sha256 "ec7916731e3ef8516336333f8b7aa9e2af51e57c0017b1e03fa43f1ba6978f64"

  bottle do
    cellar :any_skip_relocation
    sha256 "76eb602335c8e25e5cac3e5ba71427adfd77e4668cded01e9293bff24f959e0a" => :sierra
    sha256 "a8487f5efbecb0cc21542be3e923a1bd2553bdae3cda589a60f9e59e46e64e73" => :el_capitan
    sha256 "bb20915dd830cdf2c6b996af682227d7c5529d99e31fef8048e7fff513dea257" => :yosemite
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
