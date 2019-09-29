class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "http://entrproject.org/"
  url "http://entrproject.org/code/entr-4.3.tar.gz"
  sha256 "b081c1dbdac7723e91f6d528a0d736f90cb2fb1458888aa3b446699d9d26235a"

  bottle do
    cellar :any_skip_relocation
    sha256 "3b29b190745ef3babc843549b3d56ed994418f8480479f5652bddc879912e9a7" => :mojave
    sha256 "56947670876a871fb696e6b5ce08260f6a2bbd49a5f9cccb6f389e566e2d0354" => :high_sierra
    sha256 "562a8def03820db90e6d6ff40f4ac38d3f3c170b9b75f4c3ec337848013b616b" => :sierra
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
