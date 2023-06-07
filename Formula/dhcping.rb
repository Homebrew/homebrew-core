class Dhcping < Formula
  desc "Perform a dhcp-request to check whether a dhcp-server is running"
  homepage "https://www.mavetju.org/unix/general.php"
  url "https://www.mavetju.org/download/dhcping-1.2.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/d/dhcping/dhcping_1.2.orig.tar.gz"
  sha256 "32ef86959b0bdce4b33d4b2b216eee7148f7de7037ced81b2116210bc7d3646a"

  livecheck do
    url :homepage
    regex(/href=.*?dhcping[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf672145e91afa1ade387f8f7b25b78e4669c93c50ee4950d702bdb6c2eb2dea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acd8402fd7db5ab73b2dcff742d4da1cecf51e7b3c65d8da08944f45dad35b62"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8126f3068682d4e4629158c4bec5f71fe557671ee93521d4a46286fcc8a9e53a"
    sha256 cellar: :any_skip_relocation, ventura:        "8136c24d5623a25b4077432b0965d5e842f4884b82b909f807e09648a866cb66"
    sha256 cellar: :any_skip_relocation, monterey:       "42ec8be658cdb780037d554c64b7a4dc764b852eb2a29799cc46daa8e08cc0c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "cea21616fd5abd22da30648e6744ff16630f3ead891b8336ca668c3fa3f93a0a"
    sha256 cellar: :any_skip_relocation, catalina:       "6c8a4c00ebe101f4ad040238d79137025331d8af78327b77ef72d83da985402e"
    sha256 cellar: :any_skip_relocation, mojave:         "94dba411868455abd17d818d1009e71bae362cea093ec01437b19fbbb33a0cc2"
    sha256 cellar: :any_skip_relocation, high_sierra:    "e30ef14d867a06bcc9bcde18965fa00366780c3323841ca0fb25f864077044d6"
    sha256 cellar: :any_skip_relocation, sierra:         "5c41d596cb2a9835fc5f170ccd602294c98f163ba3f2a8d5c83bae252189817e"
    sha256 cellar: :any_skip_relocation, el_capitan:     "d3b03b1004d3a2d97b80fbbe9714bd29d006d9099a8f6baec343feb2833f3996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dad6d3c832c13d4199c87f8afb9bd93641b7145990edd3d0747612d3546b70cc"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end
end
