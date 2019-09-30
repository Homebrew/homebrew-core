class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "http://entrproject.org/"
  url "http://entrproject.org/code/entr-4.3.tar.gz"
  sha256 "b081c1dbdac7723e91f6d528a0d736f90cb2fb1458888aa3b446699d9d26235a"

  bottle do
    cellar :any_skip_relocation
    sha256 "c4b7c58cfb49d283b5e8abac6e42cadd35abbf839698a0768eb204fc93e7813e" => :catalina
    sha256 "aff4134c32a0a79f5717f9fc874230d4b896036550bceeab29507a6bf96b060b" => :mojave
    sha256 "0dc2105c02d0bd99bcb23e47ed0e59fe76781d230df9821fd5909ce949a2f075" => :high_sierra
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
