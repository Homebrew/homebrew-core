class Kstart < Formula
  desc "Modified version of kinit that can use keytabs to authenticate"
  homepage "https://www.eyrie.org/~eagle/software/kstart/"
  url "https://archives.eyrie.org/software/kerberos/kstart-4.3.tar.xz"
  sha256 "7a3388ae79927c6698dc1bf20b29717e6bc34f692e00f12b3369d896f6702060"

  livecheck do
    url :homepage
    regex(/href=.*?kstart[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95e851996c1269e8e1bff896243972ccfb236db690f448aad6b2369b84f366de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd2e41cf3cd5cf097f960909259741728d215c4d2ed563a4657a4c209d94bb11"
    sha256 cellar: :any_skip_relocation, monterey:       "69dc607481b782c4e341764acacd28362ce93a64c4769ab9bbaa70f9b9e827f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d34ef88ac1505c9590dd1848fd62688af3fdfef8fae4975025cae75684879c99"
    sha256 cellar: :any_skip_relocation, catalina:       "a4fe5ae0036a4ace4191f41553d3d85ba6278e933f3792eb45ad234e10046e2c"
    sha256 cellar: :any_skip_relocation, mojave:         "c024af687ae576958110ee27c4f8437c6893f4c25cec966e9f5a6e13f2aea8e9"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/k5start", "-h"
  end
end
