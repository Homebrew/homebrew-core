class Kstart < Formula
  desc "Modified version of kinit that can use keytabs to authenticate"
  homepage "https://www.eyrie.org/~eagle/software/kstart/"
  url "https://archives.eyrie.org/software/kerberos/kstart-4.3.tar.xz"
  sha256 "7a3388ae79927c6698dc1bf20b29717e6bc34f692e00f12b3369d896f6702060"
  license all_of: ["MIT", "FSFAP", "ISC"]

  livecheck do
    url :homepage
    regex(/href=.*?kstart[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "041e2a23f9396a6d7497e6931652dd9d2991aac192f93dda036ff923269fcadd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e4406b6bbb8c07dce6d556cafddb099811130501c3c377dd057f4c997ba2033c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7ca3f10529d5a1651d1e2d0a5a2940720825e35f996cb46b52ad543f7f63328"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9e3c45b4365b8c742dd32f9117cc04f297136162ce1a533c0d6d5c6ed96182b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95e851996c1269e8e1bff896243972ccfb236db690f448aad6b2369b84f366de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd2e41cf3cd5cf097f960909259741728d215c4d2ed563a4657a4c209d94bb11"
    sha256 cellar: :any_skip_relocation, sonoma:         "dfbf8bcdaf53103406b72504c67972378e7ca86cf5731e3911ade0c481ee9556"
    sha256 cellar: :any_skip_relocation, ventura:        "fc55d53dc7331b351749f1bfd22268e8c035b8997d3c7408d422dfb898f2265a"
    sha256 cellar: :any_skip_relocation, monterey:       "69dc607481b782c4e341764acacd28362ce93a64c4769ab9bbaa70f9b9e827f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d34ef88ac1505c9590dd1848fd62688af3fdfef8fae4975025cae75684879c99"
    sha256 cellar: :any_skip_relocation, catalina:       "a4fe5ae0036a4ace4191f41553d3d85ba6278e933f3792eb45ad234e10046e2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b4035780cf66ac0182d3ce1cfe54dff488f916cf2622b71cbd18f9b021da3a77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "167f4e4df9e62e2e2e0f251dccfc043d993ee47ed0d41c60ebc7916c00e3b2cc"
  end

  uses_from_macos "krb5"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"k5start", "-h"
  end
end
