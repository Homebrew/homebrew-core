class Clzip < Formula
  desc "C language version of lzip"
  homepage "https://www.nongnu.org/lzip/clzip.html"
  url "https://download.savannah.gnu.org/releases/lzip/clzip/clzip-1.13.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/clzip/clzip-1.13.tar.gz"
  sha256 "7ac9fbf5036bf50fb0b6a20e84d2293cb0d24d4044eaf33cbe9760bb9e7fea7a"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/clzip/"
    regex(/href=.*?clzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de83ba3aa6b50db57d4ccd3b563598c6e40011d0170281b5b0a9f3d44245bd97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7faa899c7e36a92d614d28d6f27ac41b4c46ec681e5e4e885ccc01cd4b988c01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de1b081d3b78675d6d98fec39e721ef5dad132fc8f6aa22b95ccdd85562986c6"
    sha256 cellar: :any_skip_relocation, ventura:        "68e6f8172636729ae858ba4b19c45a4c67d91d9c527666ea3a0aca6eacd9dcca"
    sha256 cellar: :any_skip_relocation, monterey:       "09aef3ef6a00306fa16929c87253b892e00ab1fb8c571136d914113f3a55422e"
    sha256 cellar: :any_skip_relocation, big_sur:        "fde4d37b9bde23fe59e800fb9c20fddea867152bad5e996c1083f4c0a4d99fc0"
    sha256 cellar: :any_skip_relocation, catalina:       "f72ce2568e31d226d104aa3c49e7963fcfa8096cb40460dd1f171336255a041c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f84e0c820f33a10c1d26d30d53bbea51d1cf77f8e56460f7fe293378818290d"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "testsuite"
  end

  test do
    cp_r pkgshare/"testsuite", testpath
    cd "testsuite" do
      ln_s bin/"clzip", "clzip"
      system "./check.sh"
    end
  end
end
