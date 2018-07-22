class Fdclone < Formula
  desc "Console-based file manager"
  homepage "https://hp.vector.co.jp/authors/VA012337/soft/fd/"
  url "http://www.unixusers.net/src/fdclone/FD-3.01g.tar.gz"
  sha256 "d055a2e146e40491810a210006d59722406c9ce1ef551de1d62a9fe39ffea4b4"

  bottle do
    sha256 "f51d900beceb9154a0de12860a705b6090d91217bacdefcd7d62d43827b7a6bc" => :high_sierra
    sha256 "481b0e4f245a30fc8c88d852723dcc3249e3e87fe611dfa92b9635b4180838b5" => :sierra
    sha256 "813075cfb2fe1e58896c7de5eab186b6386786f5e5c71c3c3601ad092b3609c0" => :el_capitan
  end

  depends_on "nkf" => :build

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/86107cf/fdclone/3.01b.patch"
    sha256 "c4159db3052d7e4abec57ca719ff37f5acff626654ab4c1b513d7879dcd1eb78"
  end

  def install
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}", "all"
    system "make", "MANTOP=#{man}", "install"

    %w[README FAQ HISTORY LICENSES TECHKNOW ToAdmin].each do |file|
      system "nkf", "-w", "--overwrite", file
      prefix.install "#{file}.eng" => file
      prefix.install file => "#{file}.ja"
    end

    share.install "_fdrc" => "fd2rc.dist"
  end

  def caveats; <<~EOS
    To install the initial config file:
        install -c -m 0644 #{share}/fd2rc.dist ~/.fd2rc
    To set application messages to Japanese, edit your .fd2rc:
        MESSAGELANG="ja"
  EOS
  end
end
