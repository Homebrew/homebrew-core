class Lft < Formula
  desc "Layer Four Traceroute (LFT), an advanced traceroute tool"
  homepage "https://pwhois.org/lft/"
  url "https://pwhois.org/dl/index.who?file=lft-3.98.tar.gz"
  sha256 "395ced8d95ee2bcc588a837f187e23bb25ce97999a0bb8481b2b3e0c1c633455"
  license "VOSTROM"

  livecheck do
    url :homepage
    regex(/value=.*?lft[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f89494bec6e8351e0ce8d648954f8a46bcd966b35113518df85b0b97438a1c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "419eda32f35554778ee34e24d65104e50fca5bd934de9fc2c5264fe040828f3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e0f89ea402cb4c6598e3890b25bb03c46a7f1532ec759c127eb68910497e077"
    sha256 cellar: :any_skip_relocation, sonoma:        "78c94f8f33339c225c2354822384f955ff614916f55629e65f6dae7cda03779a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fac6c8bc94198d5a1a8638fe527c54506b9368891a87e66a1eb6c2b416398101"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f5f45aab33f889b46dba96f3b077f47b5d49638d9439bc1981c299eae110615"
  end

  uses_from_macos "libpcap"

  def install
    args = %w[
      --disable-async-dns
      --disable-ncurses
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/lft -S -d 443 brew.sh 2>&1", 1)
    assert_match(/LFT: (insufficient privileges|Failed to activate capture on device)/, output)
  end
end
