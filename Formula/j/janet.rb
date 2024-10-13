class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "104aa500d4a43c2c147851823fd8b7cd06a90d01efcdff71529ff1fa68953bb4"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "bfca18a49eb89fe9e4752ceb45ee9bfd7631e5348725bb263b071d15438ab65a"
    sha256 cellar: :any,                 arm64_sonoma:   "e7c36debecfa40897430a04f17e896e0d6bfb91c9fa37b807fb6e745a9061d73"
    sha256 cellar: :any,                 arm64_ventura:  "7707626fcbfe7db67eb46ab561bbd73c25b45976923a2cad3b7a696c13d0b950"
    sha256 cellar: :any,                 arm64_monterey: "5cba1dd7c97ea227290e96d3ca1777b145e0081609facf9080e53d123fc20dd8"
    sha256 cellar: :any,                 sonoma:         "871eb81b94c60a5285aa57a3c5fb736e128ebd83897ecea299553ee4ce3797d7"
    sha256 cellar: :any,                 ventura:        "2d9485db23324a40353d08dcb52882306b7894c91b6c3b3544e6bbb5760d85f0"
    sha256 cellar: :any,                 monterey:       "5d9df5ea2af467b8046e235f2483d5e6ab98ba7ed96e8e3e71a05d4deac34529"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b06680fa89ee4af21f0985861bd923a105045f0c459243c86c4714fb4d33e3dd"
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
