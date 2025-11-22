class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/refs/tags/v1.40.1.tar.gz"
  sha256 "e7fdcb7ccc83a3be6181f7d7d71f0ea027a000e0eefe9bba3b8373c05eb5764a"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2fa3160c82a4a677ce269164b910709b28116157ea3857e49e3efb7c41bcf60a"
    sha256 cellar: :any,                 arm64_sequoia: "93b8a690c9042fe369088c02cc0913eff00ba88da180bfb108b209780a805418"
    sha256 cellar: :any,                 arm64_sonoma:  "120186d5f3c6411f0adcb97a793881a4e8d972a8b13af824e263ef087aac4df9"
    sha256 cellar: :any,                 sonoma:        "1fa642c765900c1cd7b2b0510ca0166a39f7a0e2d3ec8aa3aa6e9b562586a330"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65fc5b396bcf8cb0ef6adccc2bf37f3d1ced6efed55af1b8860c79bae5aee543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74e59dd4b45474ce5dd2b8a7666c8bc2ddee03323fbc772da0bcf3300de4d4bf"
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
