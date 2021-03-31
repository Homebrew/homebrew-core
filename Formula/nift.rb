class Nift < Formula
  desc "Cross-platform open source framework for managing and generating websites"
  homepage "https://nift.dev/"
  url "https://github.com/nifty-site-manager/nsm/archive/v2.4.8.tar.gz"
  sha256 "50c58bdc2fef7cc646381a202516c0a41949fe90972d8ef43222606d31e58294"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "58e136b7ecd542408cf98c5891ae1bf48f519b4abdd9c9695ebd4d21903a9ef2"
    sha256 cellar: :any_skip_relocation, catalina: "b941f64a90996e4b6e98bd379fe30584a0a415210d9c68eb8fbd09d9ddc2c859"
    sha256 cellar: :any_skip_relocation, mojave:   "3de44044421e8976553478f90db826b778134f3e5f08425af169a3dc67df9fe9"
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
