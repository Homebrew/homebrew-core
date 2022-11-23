class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "https://planck-repl.org/"
  url "https://github.com/planck-repl/planck/archive/2.27.0.tar.gz"
  sha256 "d69be456efd999a8ace0f8df5ea017d4020b6bd806602d94024461f1ac36fe41"
  license "EPL-1.0"
  head "https://github.com/planck-repl/planck.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "080d20e356785cea7647afcf49ac9bd1b6f2e2673a9b8d4fbf4bc21fe210b3e7"
    sha256 cellar: :any,                 arm64_monterey: "d9d378f2fa9db4cb5e669a26c98e6fd2735ad0f0e59f36493bf3cfbcb0d80dc5"
    sha256 cellar: :any,                 arm64_big_sur:  "870a011b8ee9db70210675d51d7f997c36d6d29173074e711777aa333c88c837"
    sha256 cellar: :any,                 ventura:        "57d68501020f62e385b564df8bf53d4b0ea20da90a8a5912623fd8fa6841025b"
    sha256 cellar: :any,                 monterey:       "7e79a7dc796052c2da5681c8d1609f91bd818f2bbdefd9ce8f02a09414b3d34c"
    sha256 cellar: :any,                 big_sur:        "575a4bb1d77c840f2e3e16b1d5dff64acbcddd7fd8cd61318cb01a9a54b988a2"
    sha256 cellar: :any,                 catalina:       "71720827f1deb111e07112a8f7cda8a576f5dd47596d048f8a9f9907c1f031e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc4ba6fc64eae77489a44a27d7968e2f73c218363599eed332596154dc88e744"
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
