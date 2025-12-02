class Inko < Formula
  desc "Safe and concurrent object-oriented programming language"
  homepage "https://inko-lang.org/"
  url "https://releases.inko-lang.org/0.19.1.tar.gz"
  sha256 "af39f9e9fd662523359a36011a74d24c727a8c44daaeb5b073ed4fb30ef69390"
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
    sha256 cellar: :any,                 arm64_tahoe:   "bddaed79422f3a2fb9105da1cd96c58c717de0fefb973ec2999ca2d398a3d72d"
    sha256 cellar: :any,                 arm64_sequoia: "bd6b91afa47d549e6d38fc0cac071db2afbd45f6959199c412ea7a2c6e27fd36"
    sha256 cellar: :any,                 arm64_sonoma:  "55c06dd1342079a5822b1d03fcbae4e2f1ca79114cc14087b9e35357d36ffedb"
    sha256 cellar: :any,                 sonoma:        "8008e252687334b2475f2a925990d19a32053b6e3346fb9bba79f2887eb990e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4073f68d1769c856d26625e23955bf6c98f7633bb1a115418b05ace33c7bceb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "729da31aad19a58cad802277d887e317595508da5c55e3893e56680cabd96449"
  end

  depends_on "rust" => :build
  depends_on "llvm"

  uses_from_macos "libffi"

  def install
    # Avoid statically linking to LLVM
    inreplace "compiler/Cargo.toml", 'prefer-static"]', 'force-dynamic"]'

    system "make", "build", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"hello.inko").write <<~INKO
      import std.stdio (Stdout)

      type async Main {
        fn async main {
          Stdout.new.print('Hello, world!')
        }
      }
    INKO
    assert_equal "Hello, world!\n", shell_output("#{bin}/inko run hello.inko")
  end
end
