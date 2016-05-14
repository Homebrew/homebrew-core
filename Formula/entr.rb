class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "http://entrproject.org/"
  url "http://entrproject.org/code/entr-3.5.tar.gz"
  mirror "https://bitbucket.org/eradman/entr/get/entr-3.5.tar.gz"
  sha256 "e3e455346bcaf1e9099547eb050fbf667a96610b34304e5513f90265a5976416"

  bottle do
    cellar :any_skip_relocation
    sha256 "f50782a10f3c10ef14da80fc1645261c43a0803b0bd6939c58b2d2ff0817b9a0" => :el_capitan
    sha256 "7ccda8f571d409cd95e7362d6633d3de982f5c91a9d9841ece3180d8854353f2" => :yosemite
    sha256 "1e13edf1ea820bb8bc95753b88c6d800ec26f4d0ff99f57e130a95ae53cf3483" => :mavericks
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
