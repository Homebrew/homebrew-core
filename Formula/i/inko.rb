class Inko < Formula
  desc "Safe and concurrent object-oriented programming language"
  homepage "https://inko-lang.org/"
  url "https://releases.inko-lang.org/0.16.0.tar.gz"
  sha256 "7850dc9b0f6e544977a6eb3854022131f30e49e43b99f47cc5aefb77e0b97c32"
  license "MPL-2.0"
  head "https://github.com/inko-lang/inko.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "124068300521f4cd528f4c5c52ed90793e2e87d96584ad7b6e113a39bc868053"
    sha256 cellar: :any,                 arm64_ventura:  "5a0a458153eed98bb9abcb55b330566895303fa97e47d9602a4dd9a0a7fe542c"
    sha256 cellar: :any,                 arm64_monterey: "e39be7fa100cbf341c629d63c27a2852b5185996f4182d07948c5fe053815f28"
    sha256 cellar: :any,                 sonoma:         "5496e292a1a0c997d4dc9b2186fad744477f6a099e4a2cef5af26fbffba62952"
    sha256 cellar: :any,                 ventura:        "2946c18386aa5b8580ba3090bcb04ddf1aa83897b0dd3aa9c640e0d63ab45440"
    sha256 cellar: :any,                 monterey:       "f59fd21bf0a37707ab4e4449426120fc117bcaf98a533291356c078891f19cc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7523e21bcda9eb359d1a208a4e9a71a147b6b3984c5e125a109c739ff8f7721"
  end

  depends_on "coreutils" => :build
  depends_on "rust" => :build
  depends_on "llvm"
  depends_on "zstd"

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "ncurses"
  uses_from_macos "ruby", since: :sierra
  uses_from_macos "zlib"

  on_macos do
    depends_on "z3"
  end

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].opt_libexec/"gnubin"
    system "make", "build", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"hello.inko").write <<~EOS
      import std.stdio (STDOUT)

      class async Main {
        fn async main {
          STDOUT.new.print('Hello, world!')
        }
      }
    EOS
    assert_equal "Hello, world!\n", shell_output("#{bin}/inko run hello.inko")
  end
end
