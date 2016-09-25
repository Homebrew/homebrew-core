class Mp3wrap < Formula
  desc "Wrap two or more mp3 files in a single large file"
  homepage "http://mp3wrap.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mp3wrap/mp3wrap/mp3wrap%200.5/mp3wrap-0.5-src.tar.gz"
  sha256 "1b4644f6b7099dcab88b08521d59d6f730fa211b5faf1f88bd03bf61fedc04e7"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0471701ab4f6b59423503b7c250376ba597a9f28d9962f6f9b35a107d58411ab" => :sierra
    sha256 "c65886799c1397eec33f48ef73774ad6a509fec44a18dec4a50c8755736f040a" => :el_capitan
    sha256 "50e1b97fa8423acc0c3980c7171544cf248b049d31cb1c6d3ba1214c293bc2eb" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    source = test_fixtures("test.mp3")
    system "#{bin}/mp3wrap", "#{testpath}/t.mp3", source, source
    assert File.exist? testpath/"t_MP3WRAP.mp3"
  end
end
