class Mktorrent < Formula
  desc "Create BitTorrent metainfo files"
  homepage "https://github.com/pobrn/mktorrent/wiki"
  url "https://github.com/pobrn/mktorrent/archive/refs/tags/v1.1.tar.gz"
  sha256 "d0f47500192605d01b5a2569c605e51ed319f557d24cfcbcb23a26d51d6138c9"
  license "GPL-2.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "209bb7d1d0ace5b61f05817162660ae4cd6d7d8816b9386d9e2e29a5c0e5ab49"
    sha256 cellar: :any,                 arm64_sequoia: "fb59ce178177ace7db7a6d983d42460f1141bffb09be008ed87c3373eb901701"
    sha256 cellar: :any,                 arm64_sonoma:  "3eeace6b1a58aec271d4ff3dd6097427cbe22a6f4ee068fa7340a1052b245011"
    sha256 cellar: :any,                 sonoma:        "2c724151ad0a9f666afb09a3908f8a32143a6abe9b7be39f17ed7a88c880d59b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7567016964aa6b5589e42f045d1152ef318cbfd7a8e5222aed7d15d5fa546483"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a2a18dae20156d203366dccf0b5ddd5d0803bb7b8803a2339c971051e294484"
  end

  depends_on "openssl@4"

  def install
    system "make", "USE_PTHREADS=1", "USE_OPENSSL=1", "USE_LONG_OPTIONS=1"
    bin.install "mktorrent"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      Injustice anywhere is a threat to justice everywhere.
    EOS

    system bin/"mktorrent", "-d", "-c", "Martin Luther King Jr", "test.txt"
    assert_path_exists testpath/"test.txt.torrent", "Torrent was not created"

    file = File.read(testpath/"test.txt.torrent")
    output = file.force_encoding("ASCII-8BIT") if file.respond_to?(:force_encoding)
    assert_match "Martin Luther King Jr", output
  end
end
