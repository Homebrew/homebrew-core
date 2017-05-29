class Pachi < Formula
  desc "Software for the Board Game of Go/Weiqi/Baduk"
  homepage "http://pachi.or.cz/"
  url "http://repo.or.cz/w/pachi.git/snapshot/pachi-11.00-retsugen.tar.gz"
  sha256 "2aaf9aba098d816d20950d283c8eaed522f3fa71f68390a4c384c0c1ab03cd6f"
  revision 1

  head "https://github.com/pasky/pachi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8c8017b532e93b4185eece6fd9d57290d0bfd803325a802216bc50141b510d4" => :sierra
    sha256 "d0f244e274acb8f426ff2cbdeb6f63d34a10233fe08443e9123a084ca78eb93b" => :el_capitan
    sha256 "011fe400b4fda4711de67767d2b0afcc17d8f52fe83782e423ba67539f436288" => :yosemite
  end

  fails_with :clang if MacOS.version <= :mavericks

  option "without-patterns", "Don't download pattern files for improved performance"
  option "without-book", "Don't download a fuseki opening book"

  resource "patterns" do
    url "https://sainet-dist.s3.amazonaws.com/pachi_patterns.zip"
    sha256 "73045eed2a15c5cb54bcdb7e60b106729009fa0a809d388dfd80f26c07ca7cbc"
  end

  resource "book" do
    url "https://gnugo.baduk.org/books/ra6.zip"
    sha256 "1e7ffc75c424e94338308c048aacc479da6ac5cbe77c0df8adc733956872485a"
  end

  def install
    ENV["MAC"] = "1"
    ENV["DOUBLE_FLOATING"] = "1"

    system "make"
    bin.install "pachi"

    pkgshare.install resource("patterns") if build.with? "patterns"
    pkgshare.install resource("book") if build.with? "book"
  end

  def caveats
    return if build.without?("patterns") || build.without?("book")
    <<-EOS.undent
      This formula also downloads additional data, such as opening books
      and pattern files. They are stored in #{opt_pkgshare}.

      At present, pachi cannot be pointed to external files, so make sure
      to set the working directory to #{opt_pkgshare} if you want pachi
      to take advantage of these additional files.
    EOS
  end

  test do
    assert_match /^= [A-T][0-9]+$/, pipe_output("#{bin}/pachi", "genmove b\n", 0)
  end
end
