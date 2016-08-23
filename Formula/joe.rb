class Joe < Formula
  desc "Joe's Own Editor (JOE)"
  homepage "http://joe-editor.sourceforge.net/index.html"
  url "https://downloads.sourceforge.net/project/joe-editor/JOE%20sources/joe-4.2/joe-4.2.tar.gz"
  sha256 "bc5da64bc5683ab7b2962a33214b3537ea17ff6528a3c60ba170359e31e86974"

  bottle do
    sha256 "26d743b8a2a4d5774b6bf6f205b6b30dd8fe44411f894d0bd7d6d09acad615e5" => :el_capitan
    sha256 "d6739911e38e9017999136d04c9b852110f2d625cd6048188d2618f072aaec0b" => :yosemite
    sha256 "4a7b57c3bf747ba2814f18a5f0b2a53ef005c0686b8c7c9650db67961cf384f8" => :mavericks
    sha256 "d7b0e974e3c23620df690dbbde753f87008112981b26c3166ea845d29d28a81e" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Joe's Own Editor v#{version}", shell_output("TERM=tty #{bin}/joe -help")
  end
end
