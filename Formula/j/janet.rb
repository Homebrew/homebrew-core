class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/refs/tags/v1.41.2.tar.gz"
  sha256 "168e97e1b790f6e9d1e43685019efecc4ee473d6b9f8c421b49c195336c0b725"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "d35645069c16160b7f8738de04de6ded144a4a783ab038c2a4dbea1e2976325c"
    sha256 cellar: :any, arm64_sequoia: "d40c788c83a199892cb8c683fae13efca1410116a528ff9c883c79680a298f9e"
    sha256 cellar: :any, arm64_sonoma:  "da331f1ea613e42ed71de86a065cdfbca2ece99b04bd184ddc02d001266f08e1"
    sha256 cellar: :any, sonoma:        "a8157bd738eddb480ac18e751b25b0b8d42f270bad8797a8368ce209f0ac9c9c"
    sha256 cellar: :any, arm64_linux:   "e946a22ea4bee7d8bbed43f760b5ce6a46634840006405f0e171788773cc8a64"
    sha256 cellar: :any, x86_64_linux:  "8218a627e584ab4d72ac7f87f67d408079340ba4eb109ee1dc8ccae01bc9a372"
  end

  resource "jpm" do
    url "https://github.com/janet-lang/jpm/archive/refs/tags/v1.2.0.tar.gz"
    sha256 "4282b36b44a9b35367d128982f2cfaa67370e4e5a305b3999d86a64fadd308d2"
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
    assert_path_exists jpm, "jpm must exist"
    assert_predicate jpm, :executable?, "jpm must be executable"
    assert_match syspath.to_s, shell_output("#{jpm} show-paths")
  end
end
