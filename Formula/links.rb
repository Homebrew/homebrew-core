class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.23.tar.bz2"
  sha256 "6660d202f521fd18bf5184c3f1732d1fa7426a103374277ad1cdb8e57ce6ac45"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://links.twibright.com/download.php"
    regex(/Current version is v?(\d+(?:\.\d+)+)\. /i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "863a4e88b699317bd3f79c96116ffd142afbaf046d87fa2f76a562d38ef45608"
    sha256 cellar: :any,                 big_sur:       "a318a648c86e882e797a9517304d464f1f059b35c6e5b5e22c0ea5c23f7bd304"
    sha256 cellar: :any,                 catalina:      "a90bd1693fc0808e1dc407a09a1e783c331711ee9a72082f1872733354c0c9d1"
    sha256 cellar: :any,                 mojave:        "8d83115fe0bdaf3ba1c18bf31f9df95cf8d1879af78bb910f59e402df7504383"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21d065d98860466afd5b84ddde8854cb328ae7f80d1a96d2acbfdd9f81c25519"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "openssl@1.1"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-lzma
    ]

    system "./configure", *args
    system "make", "install"
    doc.install Dir["doc/*"]
  end

  test do
    system bin/"links", "-dump", "https://duckduckgo.com"
  end
end
