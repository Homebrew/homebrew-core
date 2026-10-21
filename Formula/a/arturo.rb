class Arturo < Formula
  desc "Simple, modern and portable programming language for efficient scripting"
  homepage "https://arturo-lang.io/"
  url "https://github.com/arturo-lang/arturo/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "408646496895753608ad9dc6ddfbfa25921c03c4c7356f2832a9a63f4a7dc351"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6b1c3b757f0f08a102426ff62459c80886e7333b829ffbeba13b941b270c4844"
    sha256 cellar: :any, arm64_tahoe:       "d26c05685142a1f3f38bc8e93b30e6e7bed671a7f73219f191e62863b354c441"
    sha256 cellar: :any, arm64_sequoia:     "d59f8df9298dccbb14d97e27f97f2837d04c23cb1db172150fe77d03fa5c93fa"
    sha256 cellar: :any, arm64_linux:       "691ccd432fcb433ea59611816d14081070e184f529af3b0f7c8c3e1e6dde34c9"
    sha256 cellar: :any, x86_64_linux:      "203904c48c4b5e4e208bad2390d49c436e992fac68451adf62f63ac38acea15c"
  end

  depends_on "nim" => :build
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "openssl@4"

  # accessed via dlsym
  depends_on "pcre2" => :no_linkage

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "libxcb"
    depends_on "webkitgtk"
  end

  # Fix build with Nim 2.2.12
  patch do
    url "https://github.com/arturo-lang/arturo/commit/3e11ad40074b15103785b4a40532107b049315bc.patch?full_index=1"
    sha256 "a0720b777c37950587f71e5aa13bdb65ca8d228166d616a391d3d860580c156b"
    type :backport
  end

  def install
    # Remove bundled libraries
    rm_r("src/deps")

    # FIXME: Unbundle OpenSSL. Should find a way to do this upstream
    inreplace "src/library/Net.nim",
              /\{\.passL: "[^"]*(-lcrypto|libcrypto\.a)[^"]*"\.\}/,
              "{.passL: \"-Wl,-rpath,#{formula_opt_lib("openssl@4")} -lssl -lcrypto\".}"

    # Workaround to use pcre2 after patching `nimble`
    inreplace "src/vm/values/custom/vregex.nim",
              /\{\.passL: "[^"]*(-lpcre|libpcre\.a)[^"]*"\.\}/,
              "{.passL: \"-Wl,-rpath,#{formula_opt_lib("pcre2")}\"}"

    # Adjust installation path to homebrew one
    inreplace "build.nims", 'targetDir = getHomeDir()/".arturo"', "targetDir=\"#{prefix}\""

    system "./build.nims", "--install", "--log"
  end

  test do
    (testpath/"hello.art").write <<~EOS
      print "hello"
    EOS
    assert_equal "hello", shell_output("#{bin}/arturo #{testpath}/hello.art").chomp
  end
end
