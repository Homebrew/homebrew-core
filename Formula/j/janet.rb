class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/refs/tags/v1.37.1.tar.gz"
  sha256 "85a87115fb7b59a3fb4dab7d291627ce109eecdcf84b403ec8787ef54082519f"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b7b687820de4919f69ab25c556785820b5c57480c142cc41c900206e914c4131"
    sha256 cellar: :any,                 arm64_sonoma:  "052accbed9a01a258980e907e2b169abb85d22cb8079804e73b277bdd44f8491"
    sha256 cellar: :any,                 arm64_ventura: "464572d73e59e866753516f1816dd2326263ae6c833acd54c579b98104976a0e"
    sha256 cellar: :any,                 sonoma:        "1d5d0c02fdb0c313376862b2c6aa5e3bcb6d377ab94f92efa84d297fdb3365cf"
    sha256 cellar: :any,                 ventura:       "f7c9b539eb4188d669733cc1eab6a1fd4842fd1d363d3454da411747ea17555a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1296dfe654a771d621cfa0162166f008ce889c8554a4a7b8092d14272afa77df"
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
