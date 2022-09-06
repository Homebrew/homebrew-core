class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "https://planck-repl.org/"
  url "https://github.com/planck-repl/planck/archive/2.26.0.tar.gz"
  sha256 "e2a01ea5cefcc08399a6bfc7204b228bfd0602b1126d5968fc976f48135a59b2"
  license "EPL-1.0"
  revision 1
  head "https://github.com/planck-repl/planck.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9ce7bd1d935341e19c8649a608dc484dfad567a0db5de0100fabc8099868008e"
    sha256 cellar: :any,                 arm64_big_sur:  "15d73a32fea0cd439cc24f637aa9882f47e69e274e9ca24f45c741d5309759fc"
    sha256 cellar: :any,                 monterey:       "d7d950b46cc246bdac4a782292bcb1c280c7f4f1613778736cee12cd4d052ea2"
    sha256 cellar: :any,                 big_sur:        "a975776372c01c12ff5a19597a7fb89d37efb60c35032d6625bfe7c7a3b1388e"
    sha256 cellar: :any,                 catalina:       "35d61599097953290d2f4aa16e317df127e33abc924250f13d22a3a20433cf4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c043ce86b23e0683f5449e412eeeb3aed883f625c9127a94ed3642d7ac3add7"
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
    depends_on "gcc"
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
