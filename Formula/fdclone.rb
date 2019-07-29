class Fdclone < Formula
  desc "Console-based file manager"
  homepage "https://hp.vector.co.jp/authors/VA012337/soft/fd/"
  url "http://www.unixusers.net/src/fdclone/FD-3.01h.tar.gz"
  sha256 "24be8af52faa48cd6f123d55cfca45d21e5fd1dc16bed24f6686497429f3e2cf"

  bottle do
    sha256 "d312c649a0a3691eee27febe3c579250fda9851ae7fe800712b28dfcbd8a6beb" => :mojave
    sha256 "58aa669b9e490b8d744bb22948f1ef37549a35bbff0cbbd216ee76251d4511d9" => :high_sierra
    sha256 "0fd727178f488ed0c7f32f5b89aa6d38385ebe8377dc2c8abca84ce9777e6cae" => :sierra
    sha256 "c890b9824129c9a4ac969ff4930532841de0cce4f11274f9631029af290561ba" => :el_capitan
  end

  depends_on "nkf" => :build
  uses_from_macos "ncurses"

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

    pkgshare.install "_fdrc" => "fd2rc.dist"
  end

  def caveats; <<~EOS
    To install the initial config file:
        install -c -m 0644 #{opt_pkgshare}/fd2rc.dist ~/.fd2rc
    To set application messages to Japanese, edit your .fd2rc:
        MESSAGELANG="ja"
  EOS
  end
end
