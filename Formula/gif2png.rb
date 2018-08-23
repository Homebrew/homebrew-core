class Gif2png < Formula
  desc "Convert GIFs to PNGs"
  homepage "http://www.catb.org/~esr/gif2png/"
  url "http://www.catb.org/~esr/gif2png/gif2png-2.5.11.tar.gz"
  sha256 "40483169d2de06f632ada1de780c36f63325844ec62892b1652193f77fc508f7"

  bottle do
    cellar :any
    sha256 "fea34a3444219fe6c5a0a9929f5b5035176f792f8098e79e3ee8639baf53272b" => :mojave
    sha256 "beb6b9105619530cad31b7204952a49aa5e1c36409f2a349398399038947afa2" => :high_sierra
    sha256 "4aaa6b47a33b58d52ebd3635ec71198e1fbb75dc06234a4e482852c73ef83339" => :sierra
    sha256 "6d36f52b4d4aff69ea5a4599f1e8830a7cf9487e39d169d11155f915953ae51b" => :el_capitan
    sha256 "51e3d439570ad14778998aa06367be48a60a2d9b278ae865fa502f60307b501f" => :yosemite
    sha256 "fefb1fb3cea89f455dd7b37ead607bdeeaf0c3a3c7c342e053f2f02bac323960" => :mavericks
  end

  depends_on "libpng"

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    pipe_output "#{bin}/gif2png -O", File.read(test_fixtures("test.gif"))
  end
end
