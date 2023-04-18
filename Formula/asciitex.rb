class Asciitex < Formula
  desc "Generate ASCII-art representations of mathematical equations"
  homepage "https://asciitex.sourceforge.io"
  url "https://downloads.sourceforge.net/project/asciitex/asciiTeX-0.21.tar.gz"
  sha256 "abf964818833d8b256815eb107fb0de391d808fe131040fb13005988ff92a48d"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f12101117b2b9663ac74cfed4d14daa32fbbbc0fbeba1463063c6a151cdb0040"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99da7eb7e14ae19b86cbb881e662fbc6a67cd26c7aadd4cb038add368f9eeb3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b9cae6e65df9390c4a9a9ab55813fe05e291ca928364350d333f0389042b8d1"
    sha256 cellar: :any_skip_relocation, ventura:        "72fc542175fc6f213602a22893bdbcb784db02431dc17aba29a2509cc04fbb87"
    sha256 cellar: :any_skip_relocation, monterey:       "5e539d41ca86bb5f239671fec71d66969ffa81380fae782677f7a656f4588cb6"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d62737e9f19a499f84fb442ebc5d8738c96f44a4aeea9104a71b304a9777e6f"
    sha256 cellar: :any_skip_relocation, catalina:       "4899775d92a5f26e4b8530823593e5819b8578c44a4537c949ee4e0f6f3d5614"
    sha256 cellar: :any_skip_relocation, mojave:         "d5f864f9e6722d36da2e0412d4523a4977599c1229e3fb122bf4a0b29421c082"
    sha256 cellar: :any_skip_relocation, high_sierra:    "28a1327d58e05b74df8382ce37595d8d80decaf5cdbac4739995bc53d9f30ef7"
    sha256 cellar: :any_skip_relocation, sierra:         "9828783530514218f99ea7eabfad2031caeac979fac90cc9e049de4b4622fb80"
    sha256 cellar: :any_skip_relocation, el_capitan:     "0ae267d7ffcf17769da97275af047dc2a4ba9e5086acdb53dd11ca41f3d40ddb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "630265b0202b14fd9459b9f772f8f2c1518ddf1b5a5baf6f086f693c8054b470"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-gtk"
    inreplace "Makefile", "man/asciiTeX_gui.1", ""
    system "make", "install"
    pkgshare.install "EXAMPLES"
  end

  test do
    system "#{bin}/asciiTeX", "-f", "#{pkgshare}/EXAMPLES"
  end
end
