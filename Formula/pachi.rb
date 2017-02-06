class Pachi < Formula
  desc "pachi"
  homepage "http://pachi.or.cz/"
  url "http://repo.or.cz/w/pachi.git/snapshot/pachi-11.00-retsugen.tar.gz"
  sha256 "2aaf9aba098d816d20950d283c8eaed522f3fa71f68390a4c384c0c1ab03cd6f"
  head "https://github.com/pasky/pachi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a9dca7f4c14757f4da0b299118e9dc5d91eb3f47c117bd8ffe386c2b69c44c0" => :el_capitan
    sha256 "ac6615ed1db69c5daeb24a0ccdaa0bca3abe35d6ae3b91c0d8c952b76b52ec02" => :yosemite
    sha256 "65ae6afcb334806452449890d82bcf03c670c09345802ca977de6cbd7961ad99" => :mavericks
  end

  fails_with :clang if MacOS.version <= :mavericks

  option "without-patterns", "Don't download pattern files for improved performance"
  option "without-book", "Don't download a fuseki opening book"

  resource "patterns" do
    url "http://sainet-dist.s3.amazonaws.com/pachi_patterns.zip"
    sha256 "73045eed2a15c5cb54bcdb7e60b106729009fa0a809d388dfd80f26c07ca7cbc"
  end

  resource "book" do
    url "http://gnugo.baduk.org/books/ra6.zip"
    sha256 "1e7ffc75c424e94338308c048aacc479da6ac5cbe77c0df8adc733956872485a"
  end

  def install
    ENV["MAC"] = "1"
    ENV["DOUBLE_FLOATING"] = "1"
    system "make"
    bin.install "pachi"

    if build.with? "patterns"
      share.install resource("patterns")
    end

    if build.with? "book"
      share.install resource("book")
    end
  end

  if (build.with? "book") || (build.with? "patterns")
    def caveats; <<-EOS.undent
      This formula also downloads additional data, such as opening books and
      pattern files. They are stored in #{share}.

      At present, pachi cannot be pointed to external files, so make sure to
      set the working directory to #{share} if you
      want pachi to take advantage of these additional files.
    EOS
    end
  end

  test do
    assert_match /^= [A-T][0-9]+$/, shell_output("echo \"genmove b\" | #{bin}/pachi")
  end
end
