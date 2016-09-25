class Jshon < Formula
  desc "Parse, read, and create JSON from the shell"
  homepage "http://kmkeen.com/jshon/"
  url "http://kmkeen.com/jshon/jshon.tar.gz"
  version "8"
  sha256 "bb8ffdbda89a24f15d23af06d23fc4a9a4319503eb631cc64a5eb4c25afd45fb"

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
