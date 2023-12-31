class Inko < Formula
  desc "Safe and concurrent object-oriented programming language"
  homepage "https://inko-lang.org/"
  url "https://releases.inko-lang.org/0.13.2.tar.gz"
  sha256 "3f188a4a2242c61624081d757b66281ba0f0cfb193ebb590f1470f1f6400f773"
  license "MPL-2.0"
  head "https://github.com/inko-lang/inko.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5cd62e064bd214153243af83a9aa800b436bb39ecd2e434ed099a2b61755f151"
    sha256 cellar: :any,                 arm64_monterey: "d64fc75c7ba5595e11f32f3f4a8892dce12a24cf48d7b20ba5760ea06c4c3876"
    sha256 cellar: :any,                 ventura:        "0ae3f0e9b7ef9cdb1d11497b1f12e04daa5f2ef325fc86df7890793e63982a8e"
    sha256 cellar: :any,                 monterey:       "212ac6d6abd8a60626ca9de263451da657b49331347342b330b3be9e5ee16f57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97179c0e59b732f1b7a8a91f0a8fc07993be91c22da9f32116570f37da6176cf"
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
      import std.stdio.STDOUT

      class async Main {
        fn async main {
          STDOUT.new.print('Hello, world!')
        }
      }
    EOS
    assert_equal "Hello, world!\n", shell_output("#{bin}/inko run hello.inko")
  end
end
