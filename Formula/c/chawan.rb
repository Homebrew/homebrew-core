class Chawan < Formula
  desc "TUI web browser with CSS, inline image and JavaScript support"
  homepage "https://sr.ht/~bptato/chawan/"
  url "https://git.sr.ht/~bptato/chawan/archive/v0.5.0.tar.gz"
  sha256 "031d1ef809e1e94f16815c543a450f62a3577a7b7240ac02160dd8c78512f588"
  license "Unlicense"
  head "https://git.sr.ht/~bptato/chawan", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1fc062e3cf4d8ad13e95f4adbe3c40516994d4fa0c35866178a19c036ea8fbcc"
    sha256 cellar: :any, arm64_tahoe:       "1f2d375ce218017e6d7012d45380dd050669ccd12a82acc8b990b410202d5387"
    sha256 cellar: :any, arm64_sequoia:     "fc25664f05a415dd84daafc7ca7663fe469b2730ca26dad5df016248e74c7fe4"
    sha256 cellar: :any, arm64_linux:       "3f0c07b7448cf7bce9db6760083c3f83dc6de49e5d91725b0fe5032cf4445be0"
    sha256 cellar: :any, x86_64_linux:      "9581693ec185c30741033db06be6de7735ce16ec8a2cbc487148a4e2feb21c87"
  end

  depends_on "nim" => :build
  depends_on "pkgconf" => :build

  depends_on "brotli"
  depends_on "libssh2"
  depends_on "openssl@4"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  deny_network_access!

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cha --version")

    (testpath/"index.html").write("<h1>Hello, Homebrew!</h1>")
    assert_equal "Hello, Homebrew!", shell_output("#{bin}/cha --dump #{testpath}/index.html").strip
  end
end
