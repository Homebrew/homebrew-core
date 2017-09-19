class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "http://entrproject.org/"
  url "http://entrproject.org/code/entr-3.9.tar.gz"
  mirror "https://bitbucket.org/eradman/entr/get/entr-3.9.tar.gz"
  sha256 "a49daac8c46290f9886ac4ef3143da5b042a696c3969f6b40383e591c137d1ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d65e64b31f996f59ea61c30cebc547cee38633eed91a9882a0c22dfcb4e6e77" => :high_sierra
    sha256 "eefae48abeb986b3d0f4f60b4090bf85c86249efb42ad3a70ad65c6f690ef7af" => :sierra
    sha256 "65b4a69116adedd4b3f1677f1d2946f12d31a117527439c2eacbeff746fab7eb" => :el_capitan
    sha256 "acfa5e389ca6b0d29f3a3a62abd9f585af12b9f3edb96bb902e76badd3dcfa00" => :yosemite
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
