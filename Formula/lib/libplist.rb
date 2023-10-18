class Libplist < Formula
  desc "Library for Apple Binary- and XML-Property Lists"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libplist/releases/download/2.3.0/libplist-2.3.0.tar.bz2"
  sha256 "4e8580d3f39d3dfa13cefab1a13f39ea85c4b0202e9305c5c8f63818182cac61"
  license "LGPL-2.1-or-later"
  head "https://github.com/libimobiledevice/libplist.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1b0ee41b0b1a051a7856bb943a7fc39127009e53ae44a8728327e6f4fbec4db0"
    sha256 cellar: :any,                 arm64_ventura:  "d0848674bb98f00bff90a4fd2050199f4af5089013615232b39a1576f2aa499f"
    sha256 cellar: :any,                 arm64_monterey: "d9d090a1fb60685102e8bd96ed3c45b67790c0e8fb96307ce9afdc081657ad4f"
    sha256 cellar: :any,                 arm64_big_sur:  "7877aaa1c6c9402f87c7fd7a9acdc6f3d8b8c64cee8930f8b51e3392e5e2c571"
    sha256 cellar: :any,                 sonoma:         "5ec998b2b98947e55b3f29769a67e870da504287499454c5b8171555b3991e49"
    sha256 cellar: :any,                 ventura:        "9065713a5114093c9b7bf00dd38684efb174258cdc55aa088782c7dfc8072f3f"
    sha256 cellar: :any,                 monterey:       "a0b5c7c503c8a6f37b066f7a4681981286cfa310e775d9dffecee11909d1b7eb"
    sha256 cellar: :any,                 big_sur:        "cbfad8fed1b127f3837d6b4079b4c14198dbc56144af26c16de188c6b33b53be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99b326624adf5c2b1781060ef7692b9d0e476e73c1901eba64222be31c6a39c7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    ENV.deparallelize

    args = %w[
      --disable-silent-rules
      --without-cython
    ]

    system "./autogen.sh", *std_configure_args, *args if build.head?
    system "./configure", *std_configure_args, *args if build.stable?
    system "make"
    system "make", "install"
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
