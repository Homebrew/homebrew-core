class Lft < Formula
  desc "Layer Four Traceroute (LFT), an advanced traceroute tool"
  homepage "https://pwhois.org/lft/"
  url "https://pwhois.org/dl/index.who?file=lft-4.03.tar.gz"
  sha256 "d84aff0c2baf57a5c5b21fb3b228eed0ac0e12e5a676b3b3be13e34770b91d17"
  license "VOSTROM"

  livecheck do
    url :homepage
    regex(/value=.*?lft[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c5dd47b4eef51708b3d47b69f48d6688942d2ba1b983fffbd65f97e8e058b51c"
    sha256 cellar: :any, arm64_tahoe:       "ae55e4195d44275df1000b94d37ecdd26d1d90891d4c2f0bcb34001957b47ef2"
    sha256 cellar: :any, arm64_sequoia:     "b8ac2a1d5a00bd891f4f2030677112387d54629c3fb6d9b7d6fd37355069d08f"
    sha256 cellar: :any, arm64_linux:       "db2e4c4a97e705eef6ca4e0dd970097392b1f5551c70d48cef4b321440e09ef3"
    sha256 cellar: :any, x86_64_linux:      "eb17964795c83ef8c8c58d464da9a07ed6ec9f925b05142363841d948dd5e57b"
  end

  depends_on "pkgconf" => :build
  depends_on "c-ares"
  depends_on "ncurses"

  uses_from_macos "libpcap"

  allow_network_access! :test

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/lft -S -d 443 brew.sh 2>&1", 1)
    assert_match(/LFT: (insufficient privileges|Failed to activate capture on device)/, output)
  end
end
