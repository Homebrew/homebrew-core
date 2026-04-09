class Inko < Formula
  desc "Safe and concurrent object-oriented programming language"
  homepage "https://inko-lang.org/"
  url "https://releases.inko-lang.org/0.19.1.tar.gz"
  sha256 "2261118c98d520f61624257c6fc2b0c65782d7de2b5cd6f17245f071b1d25015"
  license "MPL-2.0"
  revision 1
  head "https://github.com/inko-lang/inko.git", branch: "main"

  # The upstream website doesn't provide easily accessible version information
  # or link to release tarballs, so we check the release manifest file that
  # the Inko version manager (`ivm`) uses.
  livecheck do
    url "https://releases.inko-lang.org/manifest.txt"
    regex(/^v?(\d+(?:\.\d+)+)$/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c9d6cce4fd8ddc942c18921f753e2a044c199f127b368ba8430e9b2386d4e9b2"
    sha256 cellar: :any,                 arm64_sequoia: "3bafd599e8e57b9433bb2f8254297880d7cfd4496594ac6fe21d6fe237b11694"
    sha256 cellar: :any,                 arm64_sonoma:  "338bcdb09b2d4940eb1dfd4f2742b6585db63615b85064047743d50ce0414e87"
    sha256 cellar: :any,                 sonoma:        "b0f312f237328f7e847f52a5e153d1c9e323786e3794e1413127d1efd73fe519"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ec14147195e7d84ea9a995cf7329b24ae6275a9cd4169fb680fa58ed4d9f39f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8eba3d51bac7359f601fdbd010525f559ce0386fcfd85cee0ae5a1d90849544"
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
