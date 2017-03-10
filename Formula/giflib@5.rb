class GiflibAT5 < Formula
  desc "Library and utilities for processing GIFs"
  homepage "http://giflib.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/giflib/giflib-5.1.3.tar.bz2"
  sha256 "5096d27805283599b01074d487ad3f8e02bd26b84d759b9017be876ca3d5b81d"

  keg_only :versioned_formula

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_match /Screen Size - Width = 1, Height = 1/, shell_output("#{bin}/giftext #{test_fixtures("test.gif")}")
  end
end
