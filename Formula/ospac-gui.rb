class OspacGui < Formula
  desc "Open Source Podcast Audio Chain - GUI"
  homepage "http://ospac.net/"
  url "https://github.com/sritterbusch/ospac/archive/v1.0.tar.gz"
  sha256 "793f0454cebe48dfa8364f26fa48469717954c31cb632a9c0b9dd24920d83f4c"

  depends_on "libsndfile"
  depends_on "fltk"
  depends_on "ospac"

  def install
    inreplace "makefile.targets" do |s|
      s.gsub! "/usr/local", prefix.to_s
      s.gsub! "cp ../ospac.1", "#cp ../ospac.1"
    end
    mkdir bin.to_s
    system "make", "ospac-gui", "install-gui"
  end

  test do
    system "ospac", "--help"
  end
end
