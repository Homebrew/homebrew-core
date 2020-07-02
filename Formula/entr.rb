class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "http://entrproject.org/"
  url "http://entrproject.org/code/entr-4.6.tar.gz"
  sha256 "16de20820df4a38162354754487b1248c8711822c7342d2f6d4f28fbd4a38e6d"
  head "https://github.com/eradman/entr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b4d9fac8d479903227ae181d1d1d7e403d7a6ebef7848be4365ad80e8e7e380" => :catalina
    sha256 "b83f3bd4f30ebcd65d22516f04ad7aec3260c75151488cc6b3ae15829872d3ec" => :mojave
    sha256 "a08481646a0439de7643b26c41d100adc099ba573aabb8ca45723ce9fbfa97e2" => :high_sierra
  end

  def install
    ENV["PREFIX"] = prefix
    ENV["MANPREFIX"] = man
    system "./configure"
    system "make"
    system "make", "install"
  end

  test do
    touch testpath/"test.1"
    fork do
      sleep 0.5
      touch testpath/"test.2"
    end
    assert_equal "New File", pipe_output("#{bin}/entr -p -d echo 'New File'", testpath).strip
  end
end
