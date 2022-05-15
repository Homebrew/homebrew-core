class Mktorrent < Formula
  desc "Create BitTorrent metainfo files"
  homepage "https://github.com/pobrn/mktorrent/wiki"
  url "https://github.com/pobrn/mktorrent/archive/v1.1.tar.gz"
  sha256 "d0f47500192605d01b5a2569c605e51ed319f557d24cfcbcb23a26d51d6138c9"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a3b1b1184becd346de3398d0f32c7f2bfc5b72700414760f2bfbb787f7ef4453"
    sha256 cellar: :any,                 arm64_big_sur:  "52e68c18ada643d382daa660c5bc697a6a6559abeba4138e87b722054668edf8"
    sha256 cellar: :any,                 monterey:       "08dbd0acde38acd472a4411cac8cb6d1e2c9a4bc2d1e609eaa8185a2ce6c3f03"
    sha256 cellar: :any,                 big_sur:        "d4f6a644ffc64e3ffba7559569abc381de67f4cbc64245d6c1548ebb1cb5262d"
    sha256 cellar: :any,                 catalina:       "3c9a180d450b8e49d1c4a6fc967df8599f602f955b7b27f8589b2052e0d77a91"
    sha256 cellar: :any,                 mojave:         "22bc8649ce5fea25549610eec4110d45f3fa1d05335cfc982df82806ff34d71b"
    sha256 cellar: :any,                 high_sierra:    "60be732dfea657c6faffa7e9d644f6ade7f974e7fea6ec46fa2941baac5eee80"
    sha256 cellar: :any,                 sierra:         "3e7f91587dbea47713351b40a99b50728a878a9eb720eca14bd125541e62606f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e0e51078893e14e1ab8c491ad7e46058f67bf61a20d89c800df6ebd3857bab3"
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
