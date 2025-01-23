class Inko < Formula
  desc "Safe and concurrent object-oriented programming language"
  homepage "https://inko-lang.org/"
  url "https://releases.inko-lang.org/0.17.1.tar.gz"
  sha256 "752c1881b7029f76f7a900ace23fbc5b81e1ceebea214c7f998c03284fd92dba"
  license "MPL-2.0"
  head "https://github.com/inko-lang/inko.git", branch: "main"

  # The upstream website doesn't provide easily accessible version information
  # or link to release tarballs, so we check the release manifest file that
  # the Inko version manager (`ivm`) uses.
  livecheck do
    url "https://releases.inko-lang.org/manifest.txt"
    regex(/^v?(\d+(?:\.\d+)+)$/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a6a054979919629af9dc5b93c3caa53863e8035085c9d0f4816d0ceaead78133"
    sha256 cellar: :any,                 arm64_sonoma:  "17e298645d17fc2f4b0aaa29d622be52b5ef2c467e65fa044eec038cc726749b"
    sha256 cellar: :any,                 arm64_ventura: "4f19eba4d1fd8a58ed8b21b56c1b8dd8912f6768e62d6d617bd1cf2d9de5a2fb"
    sha256 cellar: :any,                 sonoma:        "cb722f459dc312af8b58b861afb37d4cbcfb3bd506ed3ddca32c0bfd8acc15eb"
    sha256 cellar: :any,                 ventura:       "84c3dc1eb5b4e187055055c654f523d8c6be3d59f992857aa3dd4433013cad70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afedc35fa2c235553e564dba014a3840e38de0dee25b271f67c83208da1cacb6"
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
      import std.stdio (Stdout)

      class async Main {
        fn async main {
          Stdout.new.print('Hello, world!')
        }
      }
    EOS
    assert_equal "Hello, world!\n", shell_output("#{bin}/inko run hello.inko")
  end
end
