class Inko < Formula
  desc "Safe and concurrent object-oriented programming language"
  homepage "https://inko-lang.org/"
  url "https://releases.inko-lang.org/0.16.0.tar.gz"
  sha256 "7850dc9b0f6e544977a6eb3854022131f30e49e43b99f47cc5aefb77e0b97c32"
  license "MPL-2.0"
  revision 1
  head "https://github.com/inko-lang/inko.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dfe49ede4263ebeb9337104cc3c70e97d2348a4c9dadc57b6595f0b066f02000"
    sha256 cellar: :any,                 arm64_sonoma:  "ebbc0a383ee4e2bcbb0c0628a89bfd08338296935327e129eb3d34e53e68ca94"
    sha256 cellar: :any,                 arm64_ventura: "be38b32949b5f9e0f291c910cfa193604b93056f1498004723f1d16af038da02"
    sha256 cellar: :any,                 sonoma:        "b4fd1b5448f2284f943a7c3fcd0c01df2d81341e6f10e253b08acb22a62f013c"
    sha256 cellar: :any,                 ventura:       "90f90e0d1d5719c6fbd26502f4b3d0c87e08f1f857c4af151971fd061fc8fb8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10cacd5af2ce222ed3f5610f52f59516f0b9847d8b10d0761d60e4f00d7037fc"
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
