class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "http://entrproject.org/"
  url "http://entrproject.org/code/entr-3.7.tar.gz"
  mirror "https://bitbucket.org/eradman/entr/get/entr-3.7.tar.gz"
  sha256 "94efd50c8f7e9d569060d5deebf366c3565e81e814ab332b973d7298fa8ea22f"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c2e74139603dc5fe98455a92134c03ca95cf6a481853f89d2cd88def62b77c0" => :sierra
    sha256 "1cc87191bc5b514b2b303de9602557062ce457081d8df499a8a5e731bfee37ba" => :el_capitan
    sha256 "d8e001b3f2b5aa7b24641ff72a69c899bd5396384d110252b924781973c2f944" => :yosemite
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
