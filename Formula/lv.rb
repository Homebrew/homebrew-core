class Lv < Formula
  desc "Powerful multi-lingual file viewer/grep"
  homepage "https://web.archive.org/web/20160310122517/www.ff.iij4u.or.jp/~nrt/lv/"
  url "https://web.archive.org/web/20150915000000/www.ff.iij4u.or.jp/~nrt/freeware/lv451.tar.gz"
  version "4.51"
  sha256 "e1cd2e27109fbdbc6d435f2c3a99c8a6ef2898941f5d2f7bacf0c1ad70158bcf"

  bottle do
    rebuild 1
    sha256 "01c44c5b3d18aa1602c00bc3ce8d0b71ae02cee6dfcff66d7e8df74b424b8de8" => :sierra
    sha256 "49ad4ebf6830c1ef3f6899486e711f99bc293d422317f8851f174cf18de2a98f" => :el_capitan
    sha256 "f31281558dc9da38402a86b2b3c03efb10ab471561bf72dd556c3cd8df23ba14" => :yosemite
    sha256 "6e1894088a741aba921e77a4935d6ad2d11f06f03a4ff775c45e4256728511a4" => :mavericks
  end

  def install
    # zcat doesn't handle gzip'd data on OSX.
    # Reported upstream to nrt@ff.iij4u.or.jp
    inreplace "src/stream.c", 'gz_filter = "zcat"', 'gz_filter = "gzcat"'

    cd "build" do
      system "../src/configure", "--prefix=#{prefix}"
      system "make"
      bin.install "lv"
      bin.install_symlink "lv" => "lgrep"
    end

    man1.install "lv.1"
    (lib+"lv").install "lv.hlp"
  end
end
