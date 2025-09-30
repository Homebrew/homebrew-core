class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/refs/tags/v1.39.1.tar.gz"
  sha256 "a43489328b88846e5cddbdad9274f25ee9854e337e52490a74bb7955de03c650"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fc755cac56166891d47e91b2087f61ad44e9b2fae668288d9d07333b71caba70"
    sha256 cellar: :any,                 arm64_sequoia: "2e82b032a20adbbef5abece92554901eb1c67810c08ed523e80b3ef9701c1aaa"
    sha256 cellar: :any,                 arm64_sonoma:  "14125622a9edf9576451babc8559c29925a672dcbe771c214228fe55ffb943b1"
    sha256 cellar: :any,                 arm64_ventura: "0ba2c52edf3315a896de9af2912bf7d45d73264bd9e3cf69d68661919d415514"
    sha256 cellar: :any,                 sonoma:        "7804f267e57a24d6b45358ee2b7f912b392f58c078e512df46e87dff49114fb3"
    sha256 cellar: :any,                 ventura:       "200c5a33ee8b600a0fa4a0519aac0fe2dde1328697314b94f322971808c95e1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0e5f461d8c69ca69aeab8354cd323ade5c3f9bcd95d0f5479138c3d9ba8cd23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe6e70e686bf4871d545e9429851160559fa9d338e1849752b55e3d0398c2bee"
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
