class Nift < Formula
  desc "Cross-platform open source framework for managing and generating websites"
  homepage "https://nift.cc/"
  url "https://github.com/nifty-site-manager/nsm/archive/v2.3.10.tar.gz"
  sha256 "ef4410d423fca8dfb67a349a188a0a46bec67f7eb0157d146ae2fbb28f2f2295"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc851d7d06e5bd75038809dba48c3a37475ccd601e723da64012711a13eb2043" => :catalina
    sha256 "a45c5b4f5c182533480d9b8203827c51e54d92663c166a713ed3e62221a89b56" => :mojave
    sha256 "34054f1c1db976c98e74ed8a0a70af536d110b3032ce06f84365d1c724273b3b" => :high_sierra
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
