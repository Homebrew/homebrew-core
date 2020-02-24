class Fdclone < Formula
  desc "Console-based file manager"
  homepage "https://hp.vector.co.jp/authors/VA012337/soft/fd/"
  url "http://www.unixusers.net/src/fdclone/FD-3.01j.tar.gz"
  sha256 "fe5bb67eb670dcdb1f7368698641c928523e2269b9bee3d13b3b77565d22a121"

  bottle do
    sha256 "6272d033132a7a2c355ab19629241021087c606de3114e2ebe4aa301e6bee840" => :catalina
    sha256 "b3a56f6b62622696f4da6554a487557a57c0875c2aba28705e300b7207f6a8ce" => :mojave
    sha256 "f894bed33d254c5c48341485e835f945b60e632a0ecbf484c818f12c61350122" => :high_sierra
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
