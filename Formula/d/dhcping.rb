class Dhcping < Formula
  desc "Perform a dhcp-request to check whether a dhcp-server is running"
  homepage "http://www.mavetju.org/unix/general.php"
  url "http://www.mavetju.org/download/dhcping-1.2.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/d/dhcping/dhcping_1.2.orig.tar.gz"
  sha256 "32ef86959b0bdce4b33d4b2b216eee7148f7de7037ced81b2116210bc7d3646a"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?dhcping[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "508383a636e12497a54b8c5ee9732aaa9e3128e988fead007b84a79e871ff040"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "57a8c433ed1c7da1d25968b298425ee8c4eb654cc2c3db24ef634eb98fe2c2f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2f1f36436e5638b5410267578913125a9244b2ab37573e77f53d1be3bb46bcb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf672145e91afa1ade387f8f7b25b78e4669c93c50ee4950d702bdb6c2eb2dea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acd8402fd7db5ab73b2dcff742d4da1cecf51e7b3c65d8da08944f45dad35b62"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8126f3068682d4e4629158c4bec5f71fe557671ee93521d4a46286fcc8a9e53a"
    sha256 cellar: :any_skip_relocation, sonoma:         "efb77a8575dd69e300baf5b8dc54943a856b987dd28ef6ff92d76d7c49cd772c"
    sha256 cellar: :any_skip_relocation, ventura:        "8136c24d5623a25b4077432b0965d5e842f4884b82b909f807e09648a866cb66"
    sha256 cellar: :any_skip_relocation, monterey:       "42ec8be658cdb780037d554c64b7a4dc764b852eb2a29799cc46daa8e08cc0c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "cea21616fd5abd22da30648e6744ff16630f3ead891b8336ca668c3fa3f93a0a"
    sha256 cellar: :any_skip_relocation, catalina:       "6c8a4c00ebe101f4ad040238d79137025331d8af78327b77ef72d83da985402e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "32108c60d2bcb26968fa5a19800f076c6414e3e254857797cfd60563e75bf0b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dad6d3c832c13d4199c87f8afb9bd93641b7145990edd3d0747612d3546b70cc"
  end

  def install
    args = ["--mandir=#{man}"]
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/dhcping -c 10.0.0.2 -s 10.0.0.1 -h 34:e6:d7:0f:a9:83", 1)
    assert_match "This program should only be ran by root or be installed as setuid root.", output
  end
end
