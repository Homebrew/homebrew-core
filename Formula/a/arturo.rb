class Arturo < Formula
  desc "Simple, modern and portable programming language for efficient scripting"
  homepage "https://arturo-lang.io/"
  url "https://github.com/arturo-lang/arturo/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "408646496895753608ad9dc6ddfbfa25921c03c4c7356f2832a9a63f4a7dc351"
  license "MIT"
  revision 2

  # TODO: remove if undeprecated
  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d3d392a781457f57fbe5126ebe1914f2e84039a7cc6ba188c5c3a56346522c72"
    sha256 cellar: :any, arm64_tahoe:       "b899df59b8b96cd710949593ec374ffdddbb7f2281b7aef184a9c213e5e49fca"
    sha256 cellar: :any, arm64_sequoia:     "76cf334701487a8f5a5f98b66a3695a59bc032f90b6f87be80f1748f47236925"
    sha256 cellar: :any, arm64_linux:       "7ac8e03716bbb0f3422a570d3b45041df2885dedb4cfc80d4d0389241533b9be"
    sha256 cellar: :any, x86_64_linux:      "ddd067b4a6f5de5a27bd60b2fc7c56fc915483a97aa1e5cdc73782ca6033604d"
  end

  depends_on "nim" => :build
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "openssl@4"

  on_linux do
    disable! date: "2027-11-13", because: "needs EOL `pcre`"

    depends_on "pkgconf" => :build
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "libxcb"
    depends_on "pcre" # https://github.com/arturo-lang/arturo/issues/2027
    depends_on "webkitgtk"
  end

  # Fix build with Nim 2.2.12
  patch do
    url "https://github.com/arturo-lang/arturo/commit/3e11ad40074b15103785b4a40532107b049315bc.patch?full_index=1"
    sha256 "a0720b777c37950587f71e5aa13bdb65ca8d228166d616a391d3d860580c156b"
    type :backport
  end

  deny_network_access!

  def install
    # Remove bundled libraries
    rm_r("src/deps")

    # FIXME: Unbundle OpenSSL. Should find a way to do this upstream
    inreplace "src/library/Net.nim",
              /\{\.passL: "[^"]*(-lcrypto|libcrypto\.a)[^"]*"\.\}/,
              "{.passL: \"-Wl,-rpath,#{formula_opt_lib("openssl@4")} -lssl -lcrypto\".}"

    inreplace "src/vm/values/custom/vregex.nim",
              /\{\.passL: "[^"]*(-lpcre|libpcre\.a)[^"]*"\.\}/,
              "{.passL: \"-lpcre\"}"

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
