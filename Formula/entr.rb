class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "http://entrproject.org/"
  url "http://entrproject.org/code/entr-4.2.tar.gz"
  sha256 "27300215df0aab8b773002da25c7bf60681d8c392f5d5702946c46798e9b5d70"

  bottle do
    cellar :any_skip_relocation
    sha256 "ebeddbb2db1e63b3b272ffae240e493baa883a3b24bbbf7efdfd7a354503d8a5" => :mojave
    sha256 "52b11e50b2d4be63553eed9a303932a4f1da19fe0969d6846f38a28b26ea8fcc" => :high_sierra
    sha256 "ec7a54d7b401a96eb335cd18869c528378196ea185fdba7d00de8a38b626868c" => :sierra
    sha256 "5547fc0dd281c1478b87d53f6de5502bbab1738aa3301beea655485404b23077" => :el_capitan
  end

  head do
    url "https://bitbucket.org/eradman/entr", :using => :hg
    depends_on "mercurial" => :build
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
