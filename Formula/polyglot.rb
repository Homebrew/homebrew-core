class Polyglot < Formula
  desc "Protocol adapter to run UCI engines under XBoard"
  homepage "https://www.chessprogramming.org/PolyGlot"
  url "http://hgm.nubati.net/releases/polyglot-2.0.4.tar.gz"
  sha256 "c11647d1e1cb4ad5aca3d80ef425b16b499aaa453458054c3aa6bec9cac65fc1"
  head "http://hgm.nubati.net/git/polyglot.git", :branch => "learn"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c29c3f2dd2547bfb05fc123f997ac118fae9fccb4354d151ecdb9f4d056c792" => :catalina
    sha256 "8427c9bc2e5ca5137ee27ce8f6fc5f74cf0c216519ec20a66270fdff8547fb33" => :mojave
    sha256 "7192204bd2c30b3d2d3eb482678c76e0c6069e7bb931864a26728f961116982f" => :high_sierra
    sha256 "de7a79cd7b59fb412b245a50c601ec0546da345f5901b2bec260fba86fc27ce9" => :sierra
    sha256 "36d5170db384175c1f6f097f6d179243d265c3a06dcf34a11266cbd370be5aad" => :el_capitan
    sha256 "eff91a02101ab40e05f3479100120da2f54b1a9832cea957a054ed92872748a8" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /^PolyGlot \d\.\d\.[0-9a-z]+ by Fabien Letouzey/, shell_output("#{bin}/polyglot --help")
  end
end
