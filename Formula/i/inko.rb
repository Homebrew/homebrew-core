class Inko < Formula
  desc "Safe and concurrent object-oriented programming language"
  homepage "https://inko-lang.org/"
  url "https://releases.inko-lang.org/0.21.1.tar.gz"
  sha256 "f883b34b404fbc977775b6d38c2bcf89580fe7afe11f58f8391fa72188625cda"
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
    sha256 cellar: :any, arm64_tahoe:   "ee1709d500ff5e0138181d770aa0f5b91e0d887cbc1bda6d5e8b9c4a9d6584cf"
    sha256 cellar: :any, arm64_sequoia: "81b097dd43958a7abe8df3e74e3f33618a4ea2e709bb5bd946782a1a847f4824"
    sha256 cellar: :any, arm64_sonoma:  "e60ca11a735e27569968d3a0b237e982040c3c39d1c336447421f7f4131da411"
    sha256 cellar: :any, sonoma:        "042e07adb78d5ea74d703f5e15469d0f33520ebff5f3a8af532c9420d50ac85a"
    sha256 cellar: :any, arm64_linux:   "914b211081133b22d2eef4ebae0e4edf32915fcbce853524736bfa77eb40f6ea"
    sha256 cellar: :any, x86_64_linux:  "a75e4b8e6f7177aade61c912f03f192565e6d34a37d902a100d4c00d2eb7968b"
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
