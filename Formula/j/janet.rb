class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/refs/tags/v1.35.2.tar.gz"
  sha256 "947dfdab6c1417c7c43efef2ecb7a92a3c339ce2135233fe88323740e6e7fab1"
  license "MIT"
  revision 1
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "40f4f632fdbbae7b5f11b705515a1b6f324e8181ae988436471bb06d13aaf226"
    sha256 cellar: :any,                 arm64_ventura:  "e3876dc47ec753e6f38b7743f106a5ee27b1b39dffda25ffbea526e14e281a12"
    sha256 cellar: :any,                 arm64_monterey: "aeefa31ebc70de186e6c0a76bdb9c2c3a5b6106decf6155089d58dc16251c9b4"
    sha256 cellar: :any,                 sonoma:         "904739f0a4fd134a20413ea1b5d374a2d19381baa57044d8dcb44955ad0aaf16"
    sha256 cellar: :any,                 ventura:        "6ddc5a43bcbd95ab847f0e890c0948c29e5547d9f9f69ad7d1abec1e7e166569"
    sha256 cellar: :any,                 monterey:       "096bc375b1e29a0ef618b12ade14b481bfb632df0a579126c7e39293f734452f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21ecea304e49668de1310508cb15ed1cc33512c4548bf2417b0c4b700d3bcbc9"
  end

  resource "jpm" do
    url "https://github.com/janet-lang/jpm/archive/refs/tags/v1.1.0.tar.gz"
    sha256 "337c40d9b8c087b920202287b375c2962447218e8e127ce3a5a12e6e47ac6f16"
  end

  def syspath
    HOMEBREW_PREFIX/"lib/janet"
  end

  def install
    # Replace lines in the Makefile that attempt to create the `syspath`
    # directory (which is a directory outside the sandbox).
    inreplace "Makefile", /^.*?\bmkdir\b.*?\$\(JANET_PATH\).*?$/, "#"

    ENV["PREFIX"] = prefix
    ENV["JANET_BUILD"] = "\\\"homebrew\\\""
    ENV["JANET_PATH"] = syspath

    system "make"
    system "make", "install"
  end

  def post_install
    mkdir_p syspath unless syspath.exist?

    resource("jpm").stage do
      ENV["PREFIX"] = prefix
      ENV["JANET_BINPATH"] = HOMEBREW_PREFIX/"bin"
      ENV["JANET_HEADERPATH"] = HOMEBREW_PREFIX/"include/janet"
      ENV["JANET_LIBPATH"] = HOMEBREW_PREFIX/"lib"
      ENV["JANET_MANPATH"] = HOMEBREW_PREFIX/"share/man/man1"
      ENV["JANET_MODPATH"] = syspath
      system bin/"janet", "bootstrap.janet"
    end
  end

  def caveats
    <<~EOS
      When uninstalling Janet, please delete the following manually:
      - #{HOMEBREW_PREFIX}/lib/janet
      - #{HOMEBREW_PREFIX}/bin/jpm
      - #{HOMEBREW_PREFIX}/share/man/man1/jpm.1
    EOS
  end

  test do
    janet = bin/"janet"
    jpm = HOMEBREW_PREFIX/"bin/jpm"
    assert_equal "12", shell_output("#{janet} -e '(print (+ 5 7))'").strip
    assert_predicate jpm, :exist?, "jpm must exist"
    assert_predicate jpm, :executable?, "jpm must be executable"
    assert_match syspath.to_s, shell_output("#{jpm} show-paths")
  end
end
