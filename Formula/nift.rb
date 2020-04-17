class Nift < Formula
  desc "Cross-platform open source framework for managing and generating websites"
  homepage "https://nift.cc/"
  url "https://github.com/nifty-site-manager/nsm/archive/v2.3.3.tar.gz"
  sha256 "08bc3662b955bbd3783410cc782f802f1f08b267be08112c5c4ef0d7ecad19b3"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a711020cac8d308197840ea50741a40ff3af7e1a51c6f71630a14aee0998b31" => :catalina
    sha256 "e8ec0aebc1195fea53d45a79558f8416c7cb4337886ef8d5831bf841dbe1a78b" => :mojave
    sha256 "97e26999e073e13f0c349f438919947d8aefc9152390ed88586a9485d58cf15d" => :high_sierra
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
