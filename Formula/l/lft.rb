class Lft < Formula
  desc "Layer Four Traceroute (LFT), an advanced traceroute tool"
  homepage "https://pwhois.org/lft/"
  url "https://pwhois.org/dl/index.who?file=lft-3.96.tar.gz"
  sha256 "abeaf2c8fd607f2c45816a4ddd34f2d0a10d49e1f41f52929b8e67a0cdc24368"
  license "VOSTROM"

  livecheck do
    url :homepage
    regex(/value=.*?lft[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b35f50ca0a19210fc03e45d9c3d465489e02bdf83dda02323e19aee9bd5167fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b84d5cc93f3b5f458c23e65ff57a4b4b75fa8335427923b0e18ce58c34de789e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d59ff0139fdad8969a11f5fafccdd87eae427678781dd1e8d11db7a1a2d27476"
    sha256 cellar: :any_skip_relocation, sonoma:        "b26076567e009b86620f10e8de6a6afc6f85638499beaea05ae8b59cff734b7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "095edab26c4dd803848693e755920ec54254de383cd8dfa32db0f79dd4ab8379"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcca2c8de35adcd54722adbb1f60787a4446dd47c42701b7c051ca6be8ff3226"
  end

  uses_from_macos "libpcap"

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/lft -S -d 443 brew.sh 2>&1", 1)
    assert_match(/LFT: (insufficient privileges|Failed to activate capture on device)/, output)
  end
end
