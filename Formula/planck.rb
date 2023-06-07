class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "https://planck-repl.org/"
  url "https://github.com/planck-repl/planck/archive/2.27.0.tar.gz"
  sha256 "d69be456efd999a8ace0f8df5ea017d4020b6bd806602d94024461f1ac36fe41"
  license "EPL-1.0"
  revision 1
  head "https://github.com/planck-repl/planck.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c81dda09a6a3a8344297eaa3df9166d7b122c21a2517ffb4f0f444a44b295ec7"
    sha256 cellar: :any,                 arm64_monterey: "f54712c0e883a890d941d0a98bb221d56d5c893103127f8de7772d71eb751879"
    sha256 cellar: :any,                 arm64_big_sur:  "e63c950981cf2bed5c64b7f9b451acdfed2fa373abb088971a1812456507815d"
    sha256 cellar: :any,                 ventura:        "aef5e8e914c5a14fe894ab88d5b37c60ce46648b64d0cf4a995a5a73ae19297d"
    sha256 cellar: :any,                 monterey:       "5f89821929f06839eaeb4ec0aeaca9514318f4369ff21466f8057ead1be8cd79"
    sha256 cellar: :any,                 big_sur:        "7ba97d3ba268d49078c097cc5ee97e24d9e794d609468fc1d2e1e8d68835c6dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "831a7271ddea7ebbd62b95ae33b52ad65804cebe9a60e7a717f9d5fa035db2da"
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
