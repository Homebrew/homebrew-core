class Discount < Formula
  desc "C implementation of Markdown"
  homepage "http://www.pell.portland.or.us/~orc/Code/discount/"
  url "http://www.pell.portland.or.us/~orc/Code/discount/discount-2.2.1.tar.bz2"
  sha256 "88458c7c2cfc870f8e6cf42b300408c112e05a45c88f8af35abb33de0e96fe0e"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ea10a46d66fce3802af97f0f37a952248c1cee58156c05a6ee541149ada2c09" => :el_capitan
    sha256 "2145fa7ed31d0bebb6e134b9f8e331134fbe45de578fde37b27c1a00d9221ddc" => :yosemite
    sha256 "e30d950d0b310cd2ce649340f0518e9b313e93c6abbbb368faed82e33308b556" => :mavericks
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
end
