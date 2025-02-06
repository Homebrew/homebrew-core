class Megatools < Formula
  desc "Command-line client for Mega.co.nz"
  homepage "https://megatools.megous.com/"
  url "https://megatools.megous.com/builds/megatools-1.11.3.20250203.tar.gz"
  sha256 "37a426ecd360220c9d6c1389c19a9e8f3e07077a9d996e3fd9f756657c1df0a9"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://megatools.megous.com/builds/"
    regex(/href=.*?megatools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "19520e1d65d92271a6121eaf35024c4ffee40f0bb3eec18df9bd92e91a7d4cee"
    sha256 cellar: :any, arm64_sonoma:  "a0594f2209aa02ffc51ddadd1ff9ea20546a744b4a76c1d86199d46060418163"
    sha256 cellar: :any, arm64_ventura: "79b1ae40a19e36f9a8963ab64a7579d9a9130b43c4ab27b4245e0ffcc6c9b73e"
    sha256 cellar: :any, sonoma:        "36adde8bade90a2f874e2587fccb82bfcf1b4f28eaa26b3b245e38d4a88da716"
    sha256 cellar: :any, ventura:       "76fa318ed36ebecc48805149e8f5d6b6c98c47b3694245e57f669757589415a1"
    sha256               x86_64_linux:  "a725e2de8dfc60a6155618a361c6b0587b5672910f481ab0b973e2100247b2c2"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "openssl@3"

  uses_from_macos "curl", since: :ventura # needs curl >= 7.85.0

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # Downloads a publicly hosted file and verifies its contents.
    system bin/"megadl",
      "https://mega.co.nz/#!3Q5CnDCb!PivMgZPyf6aFnCxJhgFLX1h9uUTy9ehoGrEcAkGZSaI",
      "--path", "testfile.txt"
    assert_equal "Hello Homebrew!\n", (testpath/"testfile.txt").read
  end
end
