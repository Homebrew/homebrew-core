class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "http://entrproject.org/"
  url "http://entrproject.org/code/entr-4.0.tar.gz"
  sha256 "4ad4fe9108b179199951cfc78a581a8a69602b073dae59bcae4b810f6e1f6c8b"

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
