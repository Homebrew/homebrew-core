class Dns2tcp < Formula
  desc "TCP over DNS tunnel"
  homepage "https://packages.debian.org/sid/dns2tcp"
  url "https://deb.debian.org/debian/pool/main/d/dns2tcp/dns2tcp_0.5.2.orig.tar.gz"
  sha256 "ea9ef59002b86519a43fca320982ae971e2df54cdc54cdb35562c751704278d9"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/d/dns2tcp/"
    regex(/href=.*?dns2tcp[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "2cefc14058fc1f4bff6d872e8b5ad5e5504891f7992857a5fa8b7f469617c4d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0eb7cacef30472d6ca9cd59507d8fe3f078ad731b1e779ff8147bb2730547adb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a0bd389f540e25443deede0d0d2e1a3a5f3247cff3b49cac4d00c386f67b6e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6476349ed65c44a7cbeddff8ce0322f80ed347b7382a5108dc4128be0871161"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bcfed251acce767235024339591706ee761691a01b447acfb289f447a662cc8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7342bad79a49f0cd2049fe73e9545ae691d83087e285d97b926bd3e29b7f0643"
    sha256 cellar: :any_skip_relocation, sonoma:         "9dbcb52754890df8f97104ec51ede39386ab56db8c14790fdf91391aeba9ad6f"
    sha256 cellar: :any_skip_relocation, ventura:        "d922e172d654f0bf200d345d526ad150c57bf77376b8a022a76b98e594494100"
    sha256 cellar: :any_skip_relocation, monterey:       "02373e78d9c7f416d795a640058537f1edafb82a59b5406b019ed80b4b57c3f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "09b03661d759932c928ae63c72af41a528f6378d6f23e67e0341592ecba34a47"
    sha256 cellar: :any_skip_relocation, catalina:       "f1517166d8e8e02dbefbb654214012a6bf089ab78a1a237c9ec7d86c356da97f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3439b7a053baae453e709bbab25fc3ed8f389037b73234d0cd886ae492f51c13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44282da4806ffc130f6a3326925e708d70379c9c44ec735b251010927d5b920e"
  end

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # multiple definition of `debug'; rr.o:(.bss+0x0): first defined here
    ENV.append_to_cflags "-fcommon" if OS.linux?

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_match(/^dns2tcp v#{version} /,
                 shell_output("#{bin}/dns2tcpc -help 2>&1", 255))
  end
end
