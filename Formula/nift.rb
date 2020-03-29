class Nift < Formula
  desc "Cross-platform open source framework for managing and generating websites"
  homepage "https://nift.cc/"
  url "https://github.com/nifty-site-manager/nsm/archive/v2.2.tar.gz"
  sha256 "65d0d597aa0de5683a63e3f0524e1aa5d99e081aeb3124624c612e55b49c54be"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b571771eff85f1d7538318e583a757c578b8ff82513e06470d782eeb64b26b4" => :catalina
    sha256 "b562c11a322faff160e8c67afd7de5582db549d480eaa8f0e4493904da331579" => :mojave
    sha256 "b70e9a89d4dcd17e91a6a52e4a6a3344d38a08b0e9863d9556c42e42e5f2247a" => :high_sierra
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    mkdir "empty" do
      system "#{bin}/nsm", "init", ".html"
      assert_predicate testpath/"empty/output/index.html", :exist?
    end
  end
end
