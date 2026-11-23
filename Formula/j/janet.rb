class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/refs/tags/v1.43.1.tar.gz"
  sha256 "01e82762eac894af315db2e1e0cecdf3a935a27e2cde79ec1b8840a8a5ae0e85"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    manifest_sha256 "191d0462b744c7e1ffb17693878e9b967f90caf7a1858f6014539042d3ac2b05"
    sha256 cellar: :any, arm64_golden_gate: "30fd298f829c53e4fd8bc8f35bd9331c20fa93f417461b110fa67b24984c0c70"
    sha256 cellar: :any, arm64_tahoe:       "077dd7bd0cb4c9c43d40b0831569031d2abb0a069f7cec206c1796a8995fcbd8"
    sha256 cellar: :any, arm64_sequoia:     "fd7c5f2b4d8227a96e36f4d380d75f2a1bdefe030700ae5ed04ec8557708f2fd"
    sha256 cellar: :any, arm64_linux:       "512deb9cabf3c298aaf360316efc07dfb63d57ec77a4a6fa430da9ec41f265de"
    sha256 cellar: :any, x86_64_linux:      "028b229d9fb9a83cb3bb2a0a32b9667390c6d289a1b18b81523874ad21f1a898"
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
