class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://algol68genie.nl/en/algol-68-genie/"
  url "https://algol68genie.nl/algol68g-3.14.0.tar.gz"
  sha256 "4f3117d07f4314f1551ae0c865543466bcff7309f31b6f5819a297923f765737"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e8c4f631637031c10947d6e9ad2f4f78415a7ec3f0c83b7e2667c6e8483cc3a7"
    sha256 cellar: :any, arm64_tahoe:       "c41cb3b3181b7786567c03df7c762a28534a52e2faefbabce440975131d69b36"
    sha256 cellar: :any, arm64_sequoia:     "e876c9e38fb99023508d17c022518ea52e8201fdd0542207905f9ecce1b6bc80"
    sha256               arm64_linux:       "125ec12f604b8026bc231ed72247b2ca31a2db989a194d6a86bc189ef09cd44f"
    sha256               x86_64_linux:      "d419d2d2ba6147ff7c0096d0be10f3ccce85a4b5847ec6ac291ec2718ed707bf"
  end

  depends_on "readline"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "libpq"
  end

  deny_network_access!

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<~ALGOL
      print("Hello World")
    ALGOL

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end
