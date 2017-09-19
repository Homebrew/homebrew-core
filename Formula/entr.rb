class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "http://entrproject.org/"
  url "http://entrproject.org/code/entr-3.9.tar.gz"
  mirror "https://bitbucket.org/eradman/entr/get/entr-3.9.tar.gz"
  sha256 "a49daac8c46290f9886ac4ef3143da5b042a696c3969f6b40383e591c137d1ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "182ed754e56fd1ff6c75adead81b2d61d3346070dd314393b95a2450ca3cf787" => :sierra
    sha256 "0bbc08a677fe8a56be9487f359118802aea13c150e86826bbbccd0b52b58c9c4" => :el_capitan
  end

  head do
    url "https://bitbucket.org/eradman/entr", :using => :hg
    depends_on :hg => :build
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
