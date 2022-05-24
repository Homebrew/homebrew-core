class Polyglot < Formula
  desc "Protocol adapter to run UCI engines under XBoard"
  homepage "https://www.chessprogramming.org/PolyGlot"
  url "http://hgm.nubati.net/releases/polyglot-2.0.4.tar.gz"
  sha256 "c11647d1e1cb4ad5aca3d80ef425b16b499aaa453458054c3aa6bec9cac65fc1"
  license "GPL-2.0"
  head "http://hgm.nubati.net/git/polyglot.git", branch: "learn"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbcf961b5015dc2f909d421c6f1967a75110a44fa904718e599aa428341797d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74eb07a34cb1629966a192061f5ee507b8ff5db472b1fad9eeddba473b08570c"
    sha256 cellar: :any_skip_relocation, monterey:       "902514277b538f0d20c73875570832802028e7ba6c3f570ff0c2e4262625d7ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "96fe594c38129a85e97eed368154664e9e318fb16b3f97127a9a4e829ff47f39"
    sha256 cellar: :any_skip_relocation, catalina:       "2c29c3f2dd2547bfb05fc123f997ac118fae9fccb4354d151ecdb9f4d056c792"
    sha256 cellar: :any_skip_relocation, mojave:         "8427c9bc2e5ca5137ee27ce8f6fc5f74cf0c216519ec20a66270fdff8547fb33"
    sha256 cellar: :any_skip_relocation, high_sierra:    "7192204bd2c30b3d2d3eb482678c76e0c6069e7bb931864a26728f961116982f"
    sha256 cellar: :any_skip_relocation, sierra:         "de7a79cd7b59fb412b245a50c601ec0546da345f5901b2bec260fba86fc27ce9"
    sha256 cellar: :any_skip_relocation, el_capitan:     "36d5170db384175c1f6f097f6d179243d265c3a06dcf34a11266cbd370be5aad"
    sha256 cellar: :any_skip_relocation, yosemite:       "eff91a02101ab40e05f3479100120da2f54b1a9832cea957a054ed92872748a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d78f2053c59df94cc0389beaf43906198ebc01dcb86c8cb888fdc6c640a9bc2"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match(/^PolyGlot \d\.\d\.[0-9a-z]+ by Fabien Letouzey/, shell_output("#{bin}/polyglot --help"))
  end
end
