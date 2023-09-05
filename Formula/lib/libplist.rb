class Libplist < Formula
  desc "Library for Apple Binary- and XML-Property Lists"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libplist/archive/2.2.0.tar.gz"
  sha256 "7e654bdd5d8b96f03240227ed09057377f06ebad08e1c37d0cfa2abe6ba0cee2"
  license "LGPL-2.1"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6d101d1a75fe2859fce732e1a9448053c74707a3cdc7e10e4b67488d978b0796"
    sha256 cellar: :any,                 arm64_monterey: "b31c287f7c027c0f241dbfecb261e2a71910dcff601ceb5404ec8072dfd2a453"
    sha256 cellar: :any,                 arm64_big_sur:  "ed9c2d665d5700c91f099bd433a38ba904b63eef4d3cdc47bd0f6b0229ac689a"
    sha256 cellar: :any,                 ventura:        "df3e285aa4d7ce69059bf1609fa5d2a442e0c1434e478e5603567702d3e38760"
    sha256 cellar: :any,                 monterey:       "fd33860939e18cc5a5c50be2ca667db7d99a191aa445fefdfde51435c0f4453d"
    sha256 cellar: :any,                 big_sur:        "1ac05ef69cc02f4663fbb1c3d6d6e964c70a5ba0743d7e9e242da06864a63a70"
    sha256 cellar: :any,                 catalina:       "20faf60d286c8ceed790a9b6e34245acf7bafacc7fcbcb390d6b62e194b323e6"
    sha256 cellar: :any,                 mojave:         "768453f8710ec1c3e074ad0ebc7723da88c2b8575e5de6962ca6f1d4a85cb61d"
    sha256 cellar: :any,                 high_sierra:    "02291f2f28099a73de8fa37b49962fe575a434be63af356cceff9200c6d73f37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6677078ae6fbcfeabfee04dcb64e405f1bfcea07643752e3b5db89780404d5e"
  end

  head do
    url "https://git.sukimashita.com/libplist.git"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    ENV.deparallelize

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --without-cython
    ]

    system "./autogen.sh", *args
    system "make"
    system "make", "install", "PYTHON_LDFLAGS=-undefined dynamic_lookup"
  end

  test do
    (testpath/"test.plist").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>test</string>
        <key>ProgramArguments</key>
        <array>
          <string>/bin/echo</string>
        </array>
      </dict>
      </plist>
    EOS
    system bin/"plistutil", "-i", "test.plist", "-o", "test_binary.plist"
    assert_predicate testpath/"test_binary.plist", :exist?,
                     "Failed to create converted plist!"
  end
end
