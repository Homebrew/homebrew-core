class GiflibAT5 < Formula
  desc "Library and utilities for processing GIFs"
  homepage "https://giflib.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/giflib/giflib-5.1.3.tar.bz2"
  sha256 "5096d27805283599b01074d487ad3f8e02bd26b84d759b9017be876ca3d5b81d"

  bottle do
    cellar :any
    sha256 "0c3bdbd8d9ac59a9c3ba36cf03de74ec83188ca13b2ff04b7c3a3edf2d9aa766" => :sierra
    sha256 "867ce9ecf58dc68878d61707d94dabbbb43283407be6f8df6df2bbafc45fcaeb" => :el_capitan
    sha256 "fc867b26db799a8fb35a228cea8a0beb08d859838aaec197139ccd757178f320" => :yosemite
  end

  keg_only :versioned_formula

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_match /Screen Size - Width = 1, Height = 1/, shell_output("#{bin}/giftext #{test_fixtures("test.gif")}")
  end
end
