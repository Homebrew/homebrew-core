class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "http://entrproject.org/"
  url "http://entrproject.org/code/entr-3.9.tar.gz"
  mirror "https://bitbucket.org/eradman/entr/get/entr-3.9.tar.gz"
  sha256 "02d78f18ae530e64bfbb9d8e0250962f85946e10850dd065899d03af15f26876"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "032bd2cda96090db5b4028b8adfdbbbbb4cd5ffbfa1457df1803a3dbef337645" => :high_sierra
    sha256 "3769eac8688481d579384006f0576ebb858b6c724d574499316b0b34dbe4f4f7" => :sierra
    sha256 "83d546a3f5d6955952ac05871fcadb7be956feaef9758c45fed344c504ee1de1" => :el_capitan
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
