class Mktorrent < Formula
  desc "Create BitTorrent metainfo files"
  homepage "https://mktorrent.sourceforge.io/"
  url "https://github.com/Rudde/mktorrent/archive/v1.1.tar.gz"
  sha256 "d0f47500192605d01b5a2569c605e51ed319f557d24cfcbcb23a26d51d6138c9"
  revision 1

  bottle do
    cellar :any
    sha256 "4be468e8fd3154e5f4205d951f6ec6aa29fe814a43814ccc5ed5fbe52f2fdecd" => :mojave
    sha256 "a07987becfcb09c9246a441f5324449b7500c17a6e456a114c0583d43ad1bba1" => :high_sierra
    sha256 "9edd5b41e870ca716bad213d2ecf095e1d33b124ff150952fafc8a0d4dfd4560" => :sierra
    sha256 "6b11723fa40237afee4a17781b51c0cf6be510c3df02bca72cd5f6a299e22f24" => :el_capitan
    sha256 "d0f3f1d677e34044abcd712163c01008b56391d665daad15911acd446255c88a" => :yosemite
  end

  depends_on "openssl@1.1"

  def install
    system "make", "USE_PTHREADS=1", "USE_OPENSSL=1", "USE_LONG_OPTIONS=1"
    bin.install "mktorrent"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      Injustice anywhere is a threat to justice everywhere.
    EOS

    system bin/"mktorrent", "-d", "-c", "Martin Luther King Jr", "test.txt"
    assert_predicate testpath/"test.txt.torrent", :exist?, "Torrent was not created"

    file = File.read(testpath/"test.txt.torrent")
    output = file.force_encoding("ASCII-8BIT") if file.respond_to?(:force_encoding)
    assert_match "Martin Luther King Jr", output
  end
end
