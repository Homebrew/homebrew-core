class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "http://www.inform-fiction.org/inform6.html"

  stable do
    url "http://ifarchive.flavorplex.com/if-archive/infocom/compilers/inform6/source/inform-6.32.1.tar.gz"
    sha256 "d0526771968e6bdd79dbb09fce729ace3e18a34548b1de7e7095c5759e8f1205"

    patch do
      # Fixes case-insensitivity issue that removes critical inform6 library files
      # https://github.com/DavidGriffith/inform6unix/pull/1 (fixed in HEAD)
      url "https://gist.githubusercontent.com/ziz/f2c0554ab0fefffab54b/raw/53182f68cfb7670ab5c99ff6238e9bdd19519f0d/inform6unix-6.32.1.patch"
      sha256 "bd470d6d254002dd13bbbec8018afee24f4a2ebc1444c0b786262a847ed55a52"
    end
  end
  bottle do
    revision 1
    sha256 "298362a553b468718d19a84750b3b90c59130ccd2fc12d8f6a533ac27ba6e177" => :el_capitan
    sha256 "17ff38723a643158f9a50d59b34ea6c556dfd8a45ff704f40b6bb1cbd7d2dbd1" => :yosemite
    sha256 "5c0982e9a614c5dfcd529a060725a46624a391f45095b8bfdcadaba34834b806" => :mavericks
  end

  devel do
    url "http://ifarchive.flavorplex.com/if-archive/infocom/compilers/inform6/source/inform-6.33.1-b2.tar.gz"
    version "6.33.1-b2"
    sha256 "5e260d5114507b8294ab74f2dac35d5681fa294629a842d57811d04fa5833f8c"
  end

  head do
    url "https://github.com/DavidGriffith/inform6unix.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  resource "Adventureland.inf" do
    url "http://inform-fiction.org/examples/Adventureland/Adventureland.inf"
    sha256 "3961388ff00b5dfd1ccc1bb0d2a5c01a44af99bdcf763868979fa43ba3393ae7"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    resource("Adventureland.inf").stage do
      system "#{bin}/inform", "Adventureland.inf"
      assert File.exist? "Adventureland.z5"
    end
  end
end
