class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/refs/tags/v1.41.2.tar.gz"
  sha256 "168e97e1b790f6e9d1e43685019efecc4ee473d6b9f8c421b49c195336c0b725"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "95713b9d30546fdaab9f6f1f5f519f1cbc80089fe98afca9862639e7736ba51d"
    sha256 cellar: :any,                 arm64_sequoia: "1e161621c9e8774fdaba026fcf56a1cd8ef71ab988182784aa06a486f11a2f2f"
    sha256 cellar: :any,                 arm64_sonoma:  "7b9915ba7cdab2c07954cd308505e608c96cf88560e32998a138d54b78d6b1d4"
    sha256 cellar: :any,                 sonoma:        "dbd1061f7b9eb25f476d1f8f1c1e0a3dee4b38bfe779c78a61af65d47c0beec1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b93f65debdf478e42ade08470c501b78f89c9c4bfa759d228eb91bf9a412426c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "355439f1ee0ff6b1c47e00fb2ab241bc3d584cc9409c28b8978981095d08dd36"
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
