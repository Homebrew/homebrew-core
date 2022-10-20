class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "https://planck-repl.org/"
  url "https://github.com/planck-repl/planck/archive/2.26.0.tar.gz"
  sha256 "e2a01ea5cefcc08399a6bfc7204b228bfd0602b1126d5968fc976f48135a59b2"
  license "EPL-1.0"
  revision 1
  head "https://github.com/planck-repl/planck.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "3945ccf1866fb52c25df921bf42ac28b1d0f0b688d4c2b8b107cdd67da41c14e"
    sha256 cellar: :any,                 arm64_big_sur:  "084239c44a8993fe2d2d327053e8324d8f6b13080a1b0d22ee6a6ff36fc5561c"
    sha256 cellar: :any,                 monterey:       "8b54a20fc9bce4febcf5d377e8b62a3664bc447f4ed92036e9b85f39e5734ea4"
    sha256 cellar: :any,                 big_sur:        "ed306156976c3cc03702836ddeea68c3ce39161e8ce2c196d9eff78d421b455c"
    sha256 cellar: :any,                 catalina:       "b0e5c7f1ae5447c3226623075b3b05cb6bf9c3dd342589f8ba4d8cf6b3de1d92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea6dfa41bfb046ea891f5df7e006052297fbbe8b2290dfc06d89693d14ae2d4f"
  end

  depends_on "clojure" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: :build
  depends_on "icu4c"
  depends_on "libzip"

  uses_from_macos "vim" => :build # for xxd
  uses_from_macos "curl"
  uses_from_macos "libffi"

  on_linux do
    depends_on "glib"
    depends_on "pcre"
    depends_on "webkitgtk"
  end

  fails_with gcc: "5"

  # Apply upstream commit to fix issue with GNU sed.  Remove with next release.
  patch do
    url "https://github.com/planck-repl/planck/commit/f1f21bf9eb4cfca6312ff0117f75d3b38164b43d.patch?full_index=1"
    sha256 "787ddf6fb1cfea1d70fa18a6f7b292579ea1ffbf1f437f1f775e3330d2b8d36c"
  end

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix

    if OS.linux?
      ENV.prepend_path "PATH", Formula["openjdk"].opt_bin

      # The webkitgtk pkg-config .pc file includes the API version in its name (ex. javascriptcore-4.1.pc).
      # We extract this from the filename programmatically and store it in javascriptcore_api_version
      # and make sure planck-c/CMakeLists.txt is updated accordingly.
      # On macOS this dependency is provided by JavaScriptCore.Framework, a component of macOS.
      javascriptcore_pc_file = (Formula["webkitgtk"].lib/"pkgconfig").glob("javascriptcoregtk-*.pc").first
      javascriptcore_api_version = javascriptcore_pc_file.basename(".pc").to_s.split("-").second
      inreplace "planck-c/CMakeLists.txt", "javascriptcoregtk-4.0", "javascriptcoregtk-#{javascriptcore_api_version}"
    end

    system "./script/build-sandbox"
    bin.install "planck-c/build/planck"
    bin.install "planck-sh/plk"
    man1.install Dir["planck-man/*.1"]
  end

  test do
    assert_equal "0", shell_output("#{bin}/planck -e '(- 1 1)'").chomp
  end
end
