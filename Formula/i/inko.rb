class Inko < Formula
  desc "Safe and concurrent object-oriented programming language"
  homepage "https://inko-lang.org/"
  url "https://releases.inko-lang.org/0.21.1.tar.gz"
  sha256 "f883b34b404fbc977775b6d38c2bcf89580fe7afe11f58f8391fa72188625cda"
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
    sha256 cellar: :any, arm64_golden_gate: "2e8c529596ab78b085543352215f19cf0630a393d7eade67e56e86f93dd94619"
    sha256 cellar: :any, arm64_tahoe:       "d4be7624bff53913f827d02ced2806d64a2fde5cda782a7cee3bc029b37bccf5"
    sha256 cellar: :any, arm64_sequoia:     "8dbdc956a1e421c368ba1cd2a627fd351f7ffcda4f584f11e92072b4a2819201"
    sha256 cellar: :any, arm64_sonoma:      "c1ffd1948db727bcb73e50d0c39b243f3e1b8b77ee0ac041fbfb473c06c2aa71"
    sha256 cellar: :any, sonoma:            "79886ec7db67b6980ed6b7172fe1ce5ed31cf9942c7539d781e63066600c9abd"
    sha256 cellar: :any, arm64_linux:       "f94fdbc9a090c89840b926e64f10e709ab531f2ebce280e8b47f2b2266152c3d"
    sha256 cellar: :any, x86_64_linux:      "f6d59b3312b7ccffd1ae2cef66f17502b4f5052581e3fd7d53b8861eff5789bb"
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
