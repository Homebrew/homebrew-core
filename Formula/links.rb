class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.28.tar.bz2"
  sha256 "2fd5499b13dee59457c132c167b8495c40deda75389489c6cccb683193f454b4"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "http://links.twibright.com/download.php"
    regex(/Current version is v?(\d+(?:\.\d+)+)\. /i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "76fb5f1a9d251d92333e8df5edc86fbef944505b170064103b0b8d6461208045"
    sha256 cellar: :any,                 arm64_big_sur:  "5361e3e06d2e4fa36cfc0c1403631bb78f5c05586ec1efc202e94c644f0adeac"
    sha256 cellar: :any,                 monterey:       "6e9cd63f5a1d9afc355588214ade40ad1f1806ead876c9819381db826bb22aa9"
    sha256 cellar: :any,                 big_sur:        "7a22dc4ce071dab1a7c95b8d6ca0a9a97421356ad4eb101a7cad44ad8978c733"
    sha256 cellar: :any,                 catalina:       "fff8f7b8a3f42d039b18aaaa043228b5b9915c86ea121620f988f9eae0b44e37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fc2d0fe4b55cfeea3a19f0a68a78515d20ede04aaeea1127835d22ef5606638"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args,
                          "--mandir=#{man}",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}",
                          "--without-lzma"
    system "make", "install"
    doc.install Dir["doc/*"]
  end

  test do
    system bin/"links", "-dump", "https://duckduckgo.com"
  end
end
