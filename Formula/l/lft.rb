class Lft < Formula
  desc "Layer Four Traceroute (LFT), an advanced traceroute tool"
  homepage "https://pwhois.org/lft/"
  url "https://pwhois.org/dl/index.who?file=lft-3.99.tar.gz"
  sha256 "f34707b543391eb887ba8479f7d2c2670bfefc3afb244dc5d34a2a41d7b317eb"
  license "VOSTROM"

  livecheck do
    url :homepage
    regex(/value=.*?lft[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "933eb55aebcd31bad7a92d7f66a16112fb29c210ee304c1a3f4da88613b21ebf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d06753c89b74b036d49a9fb3ff58bb0256ef5079f3e45da74ec26d01a6ef3986"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3ceb356cdbf4981bd828eb00ca62085bfaf85fa41f22bb0041f72e3a97383ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "875ac88eb54f3107af0c6a51fedfe79b8a10f392f29646e88c81289c3cc58384"
    sha256 cellar: :any,                 arm64_linux:   "fd71aae2b9658b116d176f399a485fbe461c3c5393428ae1ced2b1dff3d9181e"
    sha256 cellar: :any,                 x86_64_linux:  "47679beec08006969cbeb24e30c2499aca5dd94361debece13329e7adc7807d6"
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
