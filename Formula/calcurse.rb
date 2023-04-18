class Calcurse < Formula
  desc "Text-based personal organizer"
  homepage "https://calcurse.org/"
  url "https://calcurse.org/files/calcurse-4.8.0.tar.gz"
  sha256 "48a736666cc4b6b53012d73b3aa70152c18b41e6c7b4807fab0f168d645ae32c"
  license "BSD-2-Clause"

  livecheck do
    url "https://calcurse.org/downloads/"
    regex(/href=.*?calcurse[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "00ec318848794f0995fc498105ba1fe7ee233a5cbddc30a959fd94a0b090ffd3"
    sha256 arm64_monterey: "c052a312420fb5e3a244df5c013c72817f3f72e6575f3d4dc2df05616d42bf77"
    sha256 arm64_big_sur:  "9e3f2eea1bab3d8e28dc2923c536a2b4585affe1c484024c684ad77dd1e75b8c"
    sha256 ventura:        "f229414cb947deb8d8ec3715ce79673767591603eebb285612ac76ab50683588"
    sha256 monterey:       "5f1bc21c76038efd7812be974b649630a982d24a1f0b9de05d229ed4cd3c471a"
    sha256 big_sur:        "157648881c6baa721a8ad91efc402f703211fdad5b9739d6221806fb42c1586c"
    sha256 catalina:       "4e711564ffefe3d1479d3ad0efec99f4c87708ad48e3e71a0c7143a9003ddab5"
    sha256 x86_64_linux:   "37bf63e3ebcd930c5019010e97c237d54171ca92c4eb7c2fdbebfd07dc290e4c"
  end

  head do
    url "https://git.calcurse.org/calcurse.git"

    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "gettext"

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # Specify XML_CATALOG_FILES for asciidoc
    system "make", "XML_CATALOG_FILES=/usr/local/etc/xml/catalog"
    system "make", "install"
  end

  test do
    system bin/"calcurse", "-v"
  end
end
