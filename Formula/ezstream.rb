class Ezstream < Formula
  desc "Client for Icecast streaming servers"
  homepage "https://icecast.org/ezstream/"
  url "https://downloads.xiph.org/releases/ezstream/ezstream-1.0.1.tar.gz"
  sha256 "fc4bf494897a8b1cf75dceefb1eb22ebd36967e5c3b5ce2af9858dbb94cf1157"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5e90210ab59dc2ff6a0a8a64b0153a59f9f63a37ec32c17d8eef21ba1112f447" => :catalina
    sha256 "45d77ec44eb517437a2b0bf73b5fd30baafae77f37bc9eb4417956261f345fe4" => :mojave
    sha256 "8dda7ec4014a1c4f13a3a17f7e243b9e7153c069f5c8cff1a20c7b2518d78be6" => :high_sierra
    sha256 "eee3cc2ed988d5c0e131d9ba8f0aef0e7bb520311096a9719b914c0a1ca6ffe4" => :sierra
    sha256 "365c26a87addf50359e65ccd98ce4244b61f7e9015a335ff47bf55a90b35ad19" => :el_capitan
    sha256 "dfa4b2537b1ce6b0da0c4214ccedca664bdd2e69962fa6579d9c437b1ff94e92" => :yosemite
    sha256 "04e3a89b8b1e91ce160ec94c981b71d8fb08d7be8fef3da3f1c33b29dc9e3f8c" => :mavericks
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "libshout"
  depends_on "taglib"

  uses_from_macos "libxml2"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.m3u").write test_fixtures("test.mp3").to_s
    system bin/"ezstream", "-s", testpath/"test.m3u"
  end
end
