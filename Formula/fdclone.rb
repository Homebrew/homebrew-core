class Fdclone < Formula
  desc "Console-based file manager"
  homepage "https://hp.vector.co.jp/authors/VA012337/soft/fd/"
  url "http://www.unixusers.net/src/fdclone/FD-3.01d.tar.gz"
  sha256 "aa33c09d2e51c486fb428e3a17c31a1db0acc3b04083b84c4f9e6259c7ffb6da"

  bottle do
    sha256 "fed1c932c964bab60d0179312e39daa56b0b6c3b80f957045c81cf9179e42412" => :high_sierra
    sha256 "1ce21a7ddf48c3ca2aef2e717c464c3c8f3741c5d6c8e75a1cb0107e48a7ceac" => :sierra
    sha256 "ed10a0556157aa545c7e01957bd6bd3c4c73370db4ca12ad99a053dce19055b8" => :el_capitan
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
