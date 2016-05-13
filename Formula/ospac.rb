class Ospac < Formula
  desc "Open Source Podcast Audio Chain"
  homepage "http://ospac.net/"
  url "https://github.com/sritterbusch/ospac/archive/v1.0.tar.gz"
  sha256 "793f0454cebe48dfa8364f26fa48469717954c31cb632a9c0b9dd24920d83f4c"

  depends_on "libsndfile"

  def install
    system "make", "ospac"
    mkdir bin.to_s
    mkdir share.to_s
    mkdir man.to_s
    mkdir man1.to_s
    cp "Release/ospac", bin.to_s
    cp "ospac.1", man1.to_s
  end

  test do
    system "ospac", "--help"
  end
end
