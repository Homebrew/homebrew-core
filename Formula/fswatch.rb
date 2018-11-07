class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.13.0/fswatch-1.13.0.tar.gz"
  sha256 "90bcf0e02fa586251aa3233cb805ca4087e81de2c5960150a0676cc42f8534bb"

  bottle do
    cellar :any
    sha256 "d6ea013ead55618fa4431c81c4292f605ed96fcf12b8b4984b4ffbf361a99c00" => :mojave
    sha256 "42b1ed99250904ab751e0f5be451967965fa8d56a9c381a9f9191d3dc7ba65ca" => :high_sierra
    sha256 "d9461e6181110454112957e8fa43cd618f4b3c26aa1dc8ae64cd7fa8455b7a97" => :sierra
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"fswatch", "-h"
  end
end
