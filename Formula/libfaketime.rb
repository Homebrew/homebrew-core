class Libfaketime < Formula
  desc "Report faked system time to programs"
  homepage "https://github.com/wolfcw/libfaketime"
  url "https://github.com/wolfcw/libfaketime/archive/v0.9.8.tar.gz"
  sha256 "06288237cd5890eca148489e5b904ed852ed0ffa8424bfb479342f4daa8442a3"
  head "https://github.com/wolfcw/libfaketime.git"

  bottle do
    sha256 "d377ea33f18d8338a134f9e9553e83e3bb591ee344884b8a49d9f72c11be0e52" => :mojave
    sha256 "30325cd15f866fdcba8749c84a43b3e331e0481e5023dbdf2366a6dd118bd036" => :high_sierra
    sha256 "0d6626a0ec194b26f82546ce84fefdcc212d6a7fb52989997257a141f0c113d0" => :sierra
  end

  # The `faketime` command needs GNU `gdate` not BSD `date`.
  # See https://github.com/wolfcw/libfaketime/issues/158 and
  # https://github.com/Homebrew/homebrew-core/issues/26568
  depends_on "coreutils"

  depends_on :macos => :sierra

  def install
    system "make", "-C", "src", "-f", "Makefile.OSX", "PREFIX=#{prefix}"
    bin.install "src/faketime"
    (lib/"faketime").install "src/libfaketime.1.dylib"
    man1.install "man/faketime.1"
  end

  test do
    cp "/bin/date", testpath/"date" # Work around SIP.
    assert_match "1230106542",
      shell_output(%Q(TZ=UTC #{bin}/faketime -f "2008-12-24 08:15:42" #{testpath}/date +%s)).strip
  end
end
