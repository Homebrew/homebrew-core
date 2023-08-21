class Pianod < Formula
  desc "Pandora client with multiple control interfaces"
  homepage "https://deviousfish.com/pianod/"
  url "https://deviousfish.com/Downloads/pianod2/pianod2-398.tar.gz"
  sha256 "4e66991a13e3a5c6a4c53c66ac9e2c96ab15e071469183b6c4e38acc69d26951"
  license "MIT"

  livecheck do
    url "https://deviousfish.com/Downloads/pianod2/"
    regex(/href=.*?pianod2[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "55d74e9ebc2a8a1fbbb19a26d82b1a8b3f58ae6f7ba9f14474a7806b8d6a398d"
    sha256 arm64_monterey: "deb01b9092fb54c22e172106b28e0f4fa9c3c370c585ae9b4f7a775a40a5bbd8"
    sha256 arm64_big_sur:  "59789677f0daab80e31665c32bb9a8cf642c37f244b8a2c273cfbf776e2b435a"
    sha256 ventura:        "be645800d92e0de4d595c8e20f745d9c442cd6ec3f71dc2742bcc078d12c596c"
    sha256 monterey:       "a8e246508edd581e5b8b3e8b9fbd175e282395d3b4eda32f29e5ab5959e96613"
    sha256 big_sur:        "50ed9be59734e6413a70d4618267e96296c5a38b91738018bc544088abfa8218"
    sha256 x86_64_linux:   "f874720872630c1add72fb66af7a918a57dc07b2788d9935ad260bed77e32103"
  end

  depends_on "pkg-config" => :build
  depends_on "gstreamer"
  depends_on "json-c"
  depends_on "libao"
  depends_on "libgcrypt"

  uses_from_macos "curl"
  uses_from_macos "libxcrypt"

  on_macos do
    depends_on "ncurses"
  end

  on_linux do
    depends_on "gnutls"
    depends_on "libbsd"
  end

  fails_with gcc: "5"

  def install
    ENV["OBJCXXFLAGS"] = "-std=c++14"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system "#{bin}/pianod", "-v"
  end
end
