class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://algol68genie.nl/en/algol-68-genie/"
  url "https://algol68genie.nl/algol68g-3.13.4.tar.gz"
  sha256 "2fc732e6f11e63f492371f6414ae0cb2205370eb4250fb9d42b74be51b81a031"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "edaecdf6dbba983026cd1a26249eeb5115f4ee3159c87b2eddfcaf8c3b621d05"
    sha256 arm64_tahoe:       "7d25747e1823e90d02584d31d75361eadb62ff41539e79ace1144a786510adac"
    sha256 arm64_sequoia:     "2a1000bd9201322a20a4350bcb438a928a66d4ab4e4d428047308b828da8463e"
    sha256 arm64_linux:       "16de22fdc0b4536307f9578c4d122ca827d4f11fd95392a621fe073663787fb1"
    sha256 x86_64_linux:      "e86499b6ebd4ccb55dc8df33ea4e0887212aabadb5e030d4c928e662afe859b8"
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
