class EvasGenericLoaders < Formula
  desc "Extra complex image type loaders for Enlightenment"
  homepage "https://enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/evas_generic_loaders/evas_generic_loaders-1.17.0.tar.gz"
  sha256 "be46c1619677dd6d1947a3db6eeaa9b8099f0e1684d72c4182304536bdb1e3dd"

  bottle do
    cellar :any
    sha256 "f9078186ad53e14970a78fe6dbd1a0f6688c9d72cda3e54b3feb042f45812b8f" => :sierra
    sha256 "8b840c0ff34d7e4d0ac146942d1d925637ac5ee990bdb59c7174c87f230620ed" => :el_capitan
    sha256 "bc91362fca88ae3b17bea974eb22ba8d262c9456668e7c3dec6a8f8169f162d1" => :yosemite
    sha256 "8c6f8dc36b315c1d1f9a2151b419e7786de781634fdc0cdd9c749d026c260394" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "efl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
