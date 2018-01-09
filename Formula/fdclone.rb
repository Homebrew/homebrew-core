class Fdclone < Formula
  desc "Console-based file manager"
  homepage "https://hp.vector.co.jp/authors/VA012337/soft/fd/"
  url "http://www.unixusers.net/src/fdclone/FD-3.01d.tar.gz"
  sha256 "aa33c09d2e51c486fb428e3a17c31a1db0acc3b04083b84c4f9e6259c7ffb6da"

  bottle do
    sha256 "14fe7c148d8e95a516c1477ccf58f041f2029731638a401346f7dfb047313175" => :high_sierra
    sha256 "ce0319a6a58dbf44dbfdd8d8716c86cf34fbb856bf660034eae9b18dc1362dc6" => :sierra
    sha256 "f9992eacec6b447a8bef9946445e371f560483799c0912e5ecd6b095bbd0b542" => :el_capitan
    sha256 "e5983768aec9c3d61a72a06ea25b121cf54178461b22f3848c446249a99b26a9" => :yosemite
    sha256 "1add0151a1961ea9b9b167b220dc0248a0fec6263efa351c2558f7eded98c361" => :mavericks
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
