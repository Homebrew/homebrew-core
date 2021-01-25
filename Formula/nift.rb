class Nift < Formula
  desc "Cross-platform open source framework for managing and generating websites"
  homepage "https://nift.cc/"
  url "https://github.com/nifty-site-manager/nsm/archive/v2.3.10.tar.gz"
  sha256 "ef4410d423fca8dfb67a349a188a0a46bec67f7eb0157d146ae2fbb28f2f2295"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd954d10e59e79bdeea45897fc6691cd7f06497c4398ec0f1f7adae62869fc01" => :big_sur
    sha256 "f08a936baa0f3e81ec0aa8343fb4970c39a7c73b308bad8df4e21fd665320ade" => :catalina
    sha256 "56e8f7ea837fbff3d3a887bd57134364c55f352c0c4e9a5bf38301dbb7e4bdda" => :mojave
    sha256 "ad7c89b1c61ba4659dff5fb3b021b3283f253e158ed72830b0598afdc33198c8" => :high_sierra
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
