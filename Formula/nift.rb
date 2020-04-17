class Nift < Formula
  desc "Cross-platform open source framework for managing and generating websites"
  homepage "https://nift.cc/"
  url "https://github.com/nifty-site-manager/nsm/archive/v2.3.2.tar.gz"
  sha256 "25e7f38fc031ac8cb5cc56f9811ef284de59759ce73f6b72368c90e789a1ea9d"

  bottle do
    cellar :any_skip_relocation
    sha256 "99e1420ac4cac5e3086baeeb89296710958a073ad8700f07ac9eb9166c9fcd71" => :catalina
    sha256 "87acd9cf82760881144ea831a3320073b48cee89ab528ca4e844392b008de7e5" => :mojave
    sha256 "d204390326a9a6fa937cc864c96c0134ace05bfcb74681091f232e2cecfedf1a" => :high_sierra
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
