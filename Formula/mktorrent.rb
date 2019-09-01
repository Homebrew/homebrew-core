class Mktorrent < Formula
  desc "Create BitTorrent metainfo files"
  homepage "https://github.com/Rudde/mktorrent/wiki"
  url "https://github.com/Rudde/mktorrent/archive/v1.1.tar.gz"
  sha256 "d0f47500192605d01b5a2569c605e51ed319f557d24cfcbcb23a26d51d6138c9"
  revision 1

  bottle do
    cellar :any
    sha256 "22bc8649ce5fea25549610eec4110d45f3fa1d05335cfc982df82806ff34d71b" => :mojave
    sha256 "60be732dfea657c6faffa7e9d644f6ade7f974e7fea6ec46fa2941baac5eee80" => :high_sierra
    sha256 "3e7f91587dbea47713351b40a99b50728a878a9eb720eca14bd125541e62606f" => :sierra
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
