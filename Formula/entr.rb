class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "http://entrproject.org/"
  url "http://entrproject.org/code/entr-3.6.tar.gz"
  mirror "https://bitbucket.org/eradman/entr/get/entr-3.6.tar.gz"
  sha256 "a42746d81c548d7e557d500f93422b8ec9731d719309eb2601b8be69ae0dc8eb"

  bottle do
    cellar :any_skip_relocation
    sha256 "be00f6e68401583e4241fa5e8b435f66670a0091eabdcbb4f3186a0373fe934e" => :sierra
    sha256 "b985e1ddf35f9804096c09e8852c24e62076a1e8e23e04905a1d09de3eb8d153" => :el_capitan
    sha256 "6d154a9923b93066f5f27b076d08124ad884c8771427f0f2d21c7f7e52f4750e" => :yosemite
    sha256 "ea4441dbe3bbf558d11559ba2decfc71bcb5ac321a9fcfc3281b5b8bd81cd03d" => :mavericks
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
