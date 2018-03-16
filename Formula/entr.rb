class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "http://entrproject.org/"
  url "http://entrproject.org/code/entr-4.0.tar.gz"
  sha256 "4ad4fe9108b179199951cfc78a581a8a69602b073dae59bcae4b810f6e1f6c8b"

  bottle do
    cellar :any_skip_relocation
    sha256 "17c3c9ad92d7506685f86093dff1e6d119e8825b9e6a3981a383730ef340a040" => :high_sierra
    sha256 "bc1976b4f61506dd65f106cf593c48d534500b9f15763746424ed8dcd557410a" => :sierra
    sha256 "e4702252f69db478d06aa9cb8d8c677f777277f0c5efe2bd9edb01d46f32440e" => :el_capitan
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
