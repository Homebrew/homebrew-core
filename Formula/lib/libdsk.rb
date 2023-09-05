class Libdsk < Formula
  desc "Library for accessing discs and disc image files"
  homepage "https://www.seasip.info/Unix/LibDsk/"
  url "https://www.seasip.info/Unix/LibDsk/libdsk-1.4.2.tar.gz"
  sha256 "71eda9d0e33ab580cea1bb507467877d33d887cea6ec042b8d969004db89901a"

  livecheck do
    url :homepage
    regex(/Stable version.*?href=.*?libdsk[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0d6d4b1f77fe027a7053571ac8b9f8bfa73cee2b52a7a570bb32946cd8aa9378"
    sha256 cellar: :any,                 arm64_monterey: "dfa9c65fe5cf50e095ed995a55c6145b3eb6702ce4a76a7e54369fff2da6ab97"
    sha256                               arm64_big_sur:  "2804cbad27cb5d942cac8be6682bc7da39f7a4c122b6f79d1e3ee58aaaea0a0b"
    sha256 cellar: :any,                 ventura:        "b78356c6b3bd08315fc58341697e69b71f2954c05155af065e39661be175482d"
    sha256 cellar: :any,                 monterey:       "3b7bf97955aa16d16ba35554bc7a171785ad16ab692c977f2ed690298866d686"
    sha256                               big_sur:        "19a28a828ba163c5bbb988cfc22e5c0a4d7a7c1f6e9cd479323c345e2175c017"
    sha256                               catalina:       "f444a8f81a4767668f4cbffa2ef09268279d23780e92b7d4bc2d6ed44c9cd675"
    sha256                               mojave:         "47485db7001965531b700308a3d464a616703ddd8fdca64c8a7d2b5049481eb5"
    sha256                               high_sierra:    "b4fa361c1800fd348c804873fd03f8663f7324eed228c3ba2e2d809a58fbbb97"
    sha256                               sierra:         "d46bdf8e9c779b22a2a21c123572c08130aa36b8a817365ee3bd76219478aad3"
    sha256                               el_capitan:     "b14fb001603c2ba33a26c0f49c7b008659ca5aa05ffaa01ab8147bac4da40d46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ca3fd61e03994cc50d7f47ebf27c2ca54b24be84292baee91664ea6d864ab33"
  end

  uses_from_macos "zlib"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    # Avoid lyx dependency
    inreplace "Makefile.in", "SUBDIRS = . include lib tools man doc",
                             "SUBDIRS = . include lib tools man"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
    doc.install Dir["doc/*.{html,pdf,sample,txt}"]
  end

  test do
    assert_equal "#{name} version #{version}\n", shell_output(bin/"dskutil --version")
  end
end
