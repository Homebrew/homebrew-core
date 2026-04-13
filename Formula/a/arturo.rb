class Arturo < Formula
  desc "Simple, modern and portable programming language for efficient scripting"
  homepage "https://arturo-lang.io/"
  url "https://github.com/arturo-lang/arturo/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "408646496895753608ad9dc6ddfbfa25921c03c4c7356f2832a9a63f4a7dc351"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ebba8e3fbb4a744beaac399da9b1ffb8307a0804d7c05b7076fb785613b5d552"
    sha256 cellar: :any,                 arm64_sequoia: "9341ba90985816c15c47bdcac2920389879773a50ef363041dc6f4ecee689fd0"
    sha256 cellar: :any,                 arm64_sonoma:  "17408c0bbc0e822b990ecff5b09984217bbb759533c9583fa4cbe522126a370d"
    sha256 cellar: :any,                 sonoma:        "1d3f1fda2e54e2a47a255e4da81b268e00cb004990957cc920bc83b5fb867c7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d022b862b9319ffddd133b8701fbc1d57c012288d0edb3a4d5481b53a3ec4f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0ca9d6b0315a3d4cd6ad14ab1b385a0cbc42d5eaa0cce0ec69241931bd2b864"
  end

  depends_on "nim" => :build
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "openssl@3"
  depends_on "pcre2" => :no_linkage # accessed via dlsym

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "libxcb"
    depends_on "webkitgtk"
  end

  def install
    # Remove bundled libraries
    rm_r("src/deps")

    # FIXME: Unbundle OpenSSL. Should find a way to do this upstream
    inreplace "src/library/Net.nim",
              /\{\.passL: "[^"]*(-lcrypto|libcrypto\.a)[^"]*"\.\}/,
              "{.passL: \"-Wl,-rpath,#{Formula["openssl@3"].opt_lib} -lssl -lcrypto\".}"

    # Workaround to use pcre2 after patching `nimble`
    inreplace "src/vm/values/custom/vregex.nim",
              /\{\.passL: "[^"]*(-lpcre|libpcre\.a)[^"]*"\.\}/,
              "{.passL: \"-Wl,-rpath,#{Formula["pcre2"].opt_lib}\"}"

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
