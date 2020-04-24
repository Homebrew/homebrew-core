class Nift < Formula
  desc "Cross-platform open source framework for managing and generating websites"
  homepage "https://nift.cc/"
  url "https://github.com/nifty-site-manager/nsm/archive/v2.3.5.tar.gz"
  sha256 "d0d6d5a39a8be7ab381e31570f21652859cd845c979c731e2cc2e936860aca0c"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7e7aa6af70b62b847d620080276b4b835c2b70f8ffed91a2af6a2dd7f01a62c" => :catalina
    sha256 "07614528c96c910169477165a83dd3d8fb5db747df3918897c5eb9377347e16d" => :mojave
    sha256 "8a4fca1c254e90bfb5ff499e5c7d333a79049a29e00b09140219246e458f735a" => :high_sierra
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
