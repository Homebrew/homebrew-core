class Antiword < Formula
  desc "Utility to read Word (.doc) files"
  homepage "http://www.winfield.demon.nl/"
  url "http://www.winfield.demon.nl/linux/antiword-0.37.tar.gz"
  mirror "https://fossies.org/linux/misc/old/antiword-0.37.tar.gz"
  sha256 "8e2c000fcbc6d641b0e6ff95e13c846da3ff31097801e86702124a206888f5ac"

  livecheck do
    url "http://www.winfield.demon.nl/linux/"
    regex(/href=.*?antiword[._-]v?(\d+(?:\.\d+)+)\.t[a-z]+(?:\.[a-z]+)?["' >]/i)
  end

  bottle do
    sha256 arm64_monterey: "3d34f162686148d496bee36265f1434f11daf29957de15c4bdce8ba386f90fc9"
    sha256 arm64_big_sur:  "b47c2693abcaa8e3b9bc14a4239b1cd857f66f1fa381009659b7e1bc7f7d52c2"
    sha256 monterey:       "2532dc5dd6a92569c650fd6bb490fae31c49d79234948c224f51df5910fbecc9"
    sha256 big_sur:        "d155e9094844588db872b6791fe727bb72fac4a72d9897bac768a813c1bf273a"
    sha256 catalina:       "7f62624bf238ba077370f6e8e223704b57eee461f2bbaddc47de8e4b5c5a4eda"
    sha256 mojave:         "63b4aa9e31936c405039161b1ae728d76472bb9932a7b460e1fdd7a1276ee5ad"
    sha256 high_sierra:    "cacd3e8a83231fd139a5b845f17fb99a34f728d10df2eb6289457037ee8c827f"
    sha256 sierra:         "6456be83a3f867a0df1121b7c7b6c413d94d1e38bc920c9c5fda73851265fb2e"
    sha256 el_capitan:     "ffc3b61781ffb2ae04537e34b28a19a4fe33683c534dd2d1504d2ec8d5ef4bef"
    sha256 yosemite:       "1397c95409d671da764658460eba612b2564d4a0403bfffa667510e05f2fb08a"
    sha256 x86_64_linux:   "12935daff8ed3ffc2a68b8be542ea190bff6d7d2a2d46c854080d4023346d526"
  end

  resource "testdoc.doc" do
    url "https://github.com/rsdoiel/antiword/raw/fe4b579067122a2d9d62647efb1ee7cfe3ca92bb/Docs/testdoc.doc"
    sha256 "4ea5fe94a8ff9d8cd1e21a5e233efb681f2026de48ab1ac2cbaabdb953ca25ac"
  end

  def install
    inreplace "antiword.h", "/usr/share/antiword", pkgshare

    system "make", "CC=#{ENV.cc}",
                   "LD=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags} -DNDEBUG",
                   "GLOBAL_INSTALL_DIR=#{bin}",
                   "GLOBAL_RESOURCES_DIR=#{pkgshare}"
    bin.install "antiword"
    pkgshare.install Dir["Resources/*"]
    man1.install "Docs/antiword.1"
  end

  def caveats
    <<~EOS
      You can install mapping files in ~/.antiword
    EOS
  end

  test do
    resource("testdoc.doc").stage do
      assert_match <<~EOS, shell_output("#{bin}/antiword testdoc.doc")
        This is just a small test document.


        This is just a small document to see if Antiword has been compiled
        correctly.
        The images will only show in the PostScript mode.

        [pic]

        Figure 1

        This JPEG image is the Antiword icon.

        [pic]

        Figure 2
      EOS
    end
  end
end
