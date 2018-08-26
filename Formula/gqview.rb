class Gqview < Formula
  desc "Image browser"
  homepage "https://gqview.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gqview/gqview/2.0.4/gqview-2.0.4.tar.gz"
  sha256 "97e3b7ce5f17a315c56d6eefd7b3a60b40cc3d18858ca194c7e7262acce383cb"
  revision 2

  bottle do
    sha256 "70c9791ca8c487ce98719f09ef52016ec31f801746ee52b9971bfe13bcd7119d" => :mojave
    sha256 "996c7675700a1d21e4ce3e0f009a8c0cc7c82f3d8272b18c66b389a96c9458b1" => :high_sierra
    sha256 "175f47cf8461ba1d389bc9532ba4e458b1531a452ff873f1a7a20c165e0900d0" => :sierra
    sha256 "9d80117cb9375f410886275318f9373f91ff29114cb5d4a62e1f801548364f47" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/gqview", "--version"
  end
end
