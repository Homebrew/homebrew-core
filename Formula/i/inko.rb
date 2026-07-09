class Inko < Formula
  desc "Safe and concurrent object-oriented programming language"
  homepage "https://inko-lang.org/"
  url "https://releases.inko-lang.org/0.20.0.tar.gz"
  sha256 "14356c5fd0a024a0ea5efb62c68bc404cd97325cfa78f0daee5d7f61bbcf407a"
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
    sha256 cellar: :any,                 arm64_tahoe:   "de85bb77207af2a479666d3d74eedb2bb07829db0bcdd5c7b4198ebf983daafa"
    sha256 cellar: :any,                 arm64_sequoia: "9792044d4821e5cb674df291fce3dcc78cc3d9902fe7ab6a05cecf3b91d4a203"
    sha256 cellar: :any,                 arm64_sonoma:  "7df0aa33f7887f2a8276bd8a1f2a4f8b073f78e90838762e379865a894ab9e8c"
    sha256 cellar: :any,                 sonoma:        "1c4d68f66ddd8123df0c405d6fd6fc7ddd8d3e651a13942a952ff7c866f2a2c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48d02f0c7220f3588ba1de594b0fab258927a357d99b6eeee227e6ad324ebbdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52ff47e77cfddaf91e24b11b68948bff67517dc20a3a1bc396aa1333d5a6adca"
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
