class Jshon < Formula
  desc "Parse, read, and create JSON from the shell"
  homepage "http://kmkeen.com/jshon/"
  url "https://github.com/keenerd/jshon/archive/20131105.tar.gz"
  sha256 "28420f6f02c6b762732898692cc0b0795cfe1a59fbfb24e67b80f332cf6d4fa2"

  bottle do
    cellar :any
    sha256 "eaf121512303610e873d508312acc46547c3399f4171e08a7a391ed5f0604786" => :sierra
    sha256 "96c3b3298a7975eacf2135f3b75a21a4a2d4df94f3b0b54a83a58da6e83148db" => :el_capitan
    sha256 "6b58d61da14d8f458290888b7576a44ec12daa26077f94d8bbeb406fb165d117" => :yosemite
    sha256 "66e48123e2b04de8f829cf861590d336b64215623aafc846ee9e6d6eda4aed57" => :mavericks
  end

  depends_on "jansson"

  def install
    system "make"
    bin.install "jshon"
    man1.install "jshon.1"
  end

  test do
    assert_equal "3", pipe_output("#{bin}/jshon -l", "[true,false,null]").strip
  end
end
