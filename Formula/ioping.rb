class Ioping < Formula
  desc "Tool to monitor I/O latency in real time"
  homepage "https://github.com/koct9i/ioping"
  url "https://github.com/koct9i/ioping/archive/v1.0.tar.gz"
  sha256 "db999abb0f9de00bce800267965cdd9b826ebce6052e905b12d9f40076157088"

  head "https://github.com/koct9i/ioping.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b686bc05884339642374568ca3cdab6cdb0bb10513c81e91ce44595150fb24b" => :sierra
    sha256 "20ced9a086650e90c0bf5d1fe475833e9f6e42036997381c4f41156d09b7f300" => :el_capitan
    sha256 "3e41312ac455f0901b365b8c60de6c55869cea417ce57960ed9affb9721690d0" => :yosemite
    sha256 "e0c9fd5902a4147e866f38c4d4123f9133ad7cfbe10ab1f9d2e78a887ee0603a" => :mavericks
    sha256 "a01eb9b7c2a39d65fcfc55a70be1333ec0f1df19ad2582dec81a6e40b7ab95c8" => :mountain_lion
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ioping", "-c", "1", testpath
  end
end
