class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/refs/tags/v1.41.2.tar.gz"
  sha256 "168e97e1b790f6e9d1e43685019efecc4ee473d6b9f8c421b49c195336c0b725"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_tahoe:   "a93d5b5ff09c0edcef0ca663382ccf0381211c65c3967c4470bc77dcfbf32934"
    sha256 cellar: :any, arm64_sequoia: "23120fcd8728d8991a81874c8e06eec53fcc2e3040d52b0aa581b368fbc00199"
    sha256 cellar: :any, arm64_sonoma:  "d5a8f324cd412dccbaed4804dbfa7e649af71220074d930d0241d580b917900b"
    sha256 cellar: :any, sonoma:        "8f375d8552786209a679fddedbbb90fa6a71694d15360a3b2ab37823ee9af64b"
    sha256 cellar: :any, arm64_linux:   "2876701042e054dfedfdeca3b0e6cead6435ef7ef9ab9567634015a02c75bd18"
    sha256 cellar: :any, x86_64_linux:  "d6b990d082441847ad534e88f09c0b5e85a456e809b6370a44977f181ce4f681"
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

    resource("jpm").stage do
      (libexec/"jpm").install Dir["*"]
    end
  end

  post_install_steps do
    mkdir_p "{{HOMEBREW_PREFIX}}/lib/janet"
    run "janet", args: ["bootstrap.janet"], base: :bin, chdir: "{{libexec}}/jpm",
         env: {
           "PREFIX"           => "{{prefix}}",
           "JANET_BINPATH"    => "{{HOMEBREW_PREFIX}}/bin",
           "JANET_HEADERPATH" => "{{HOMEBREW_PREFIX}}/include/janet",
           "JANET_LIBPATH"    => "{{HOMEBREW_PREFIX}}/lib",
           "JANET_MANPATH"    => "{{HOMEBREW_PREFIX}}/share/man/man1",
           "JANET_MODPATH"    => "{{HOMEBREW_PREFIX}}/lib/janet",
         }
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
