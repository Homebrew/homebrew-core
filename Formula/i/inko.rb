class Inko < Formula
  desc "Safe and concurrent object-oriented programming language"
  homepage "https://inko-lang.org/"
  url "https://releases.inko-lang.org/0.12.0.tar.gz"
  sha256 "56584ece9d1522401d0855d3d103ee7e53fee74f12441a5e26b32f8d5eb934b8"
  license "MPL-2.0"
  head "https://github.com/inko-lang/inko.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e4dfd8dfcabe4bd91017d969517af9a78a615aa12ba4701358bab0324ae6b26d"
    sha256 cellar: :any,                 arm64_monterey: "858877702a14e0023d3689ac9d06dc5552cca998aad329e5d5a43d32b54a22f2"
    sha256 cellar: :any,                 arm64_big_sur:  "9879147562ae214c4e76c94a32426fb8710ee0475e60b843af4b9b931881adb2"
    sha256 cellar: :any,                 ventura:        "ffed66f5e2fc27db2f93eec8a9f821e20ad58fec79934eac28591fb36fa8fb79"
    sha256 cellar: :any,                 monterey:       "3f421d39d79e0c0fa39e0878776cf116baacf618e89bdeaec89545fe3098c074"
    sha256 cellar: :any,                 big_sur:        "24d398103166917fdf3813e1796957b4bd59d5d8c8ba580a62e2696bb0872030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd48e9a3878a214c379efe9470ed433c0402a67c0948946b511442dd33fdc097"
  end

  depends_on "coreutils" => :build
  depends_on "llvm@15" => :build
  depends_on "rust" => :build
  depends_on "zstd"

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "ruby", since: :sierra

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].opt_libexec/"gnubin"
    system "make", "build", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"hello.inko").write <<~EOS
      import std::stdio::STDOUT

      class async Main {
        fn async main {
          STDOUT.new.print('Hello, world!')
        }
      }
    EOS
    assert_equal "Hello, world!\n", shell_output("#{bin}/inko run hello.inko")
  end
end
