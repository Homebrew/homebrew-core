class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/refs/tags/v1.38.0.tar.gz"
  sha256 "84dbf7db9c09677618549fb4be23631fd64f527af21051db02753241a2f6f752"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3d5aceab74176cbe27ffae5a7fa4f9485c2694989188fcd5f7c4a83ff2a4495d"
    sha256 cellar: :any,                 arm64_sonoma:  "2afce57bcb9348d81aa482af206fbfa1d6b1985f028be51fef0d5e6f6ccc42e3"
    sha256 cellar: :any,                 arm64_ventura: "ccdaeff23165fc3b9fc964a18a010dd0804a91cc615c25be653f0f59f401886c"
    sha256 cellar: :any,                 sonoma:        "02fb4e9f90e09f7ba732c33f5db175650f074f42a2d144d2ec140ac4594d0972"
    sha256 cellar: :any,                 ventura:       "db28b206bd0846582f5d299e02879624716b1ba5d87ebdc3819b1dd202c3ad6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3c3fe2618d5ca8b0458ecb473531c16f9deb97a8bd4de18228507f97252fae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "029c616c9c076e8fcc8a8a144df67dc5427dbad79903329a5accaadf26bc487a"
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
    assert_path_exists jpm, "jpm must exist"
    assert_predicate jpm, :executable?, "jpm must be executable"
    assert_match syspath.to_s, shell_output("#{jpm} show-paths")
  end
end
