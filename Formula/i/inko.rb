class Inko < Formula
  desc "Safe and concurrent object-oriented programming language"
  homepage "https://inko-lang.org/"
  url "https://releases.inko-lang.org/0.13.1.tar.gz"
  sha256 "c674d58dd4b044dbfa40b13f444f4f3c0e632fc900ae906d56f39070ba62e846"
  license "MPL-2.0"
  head "https://github.com/inko-lang/inko.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a4d9af578840ee114d88147d6570fb99db339697d6ec0fb0e76387a5309eefb9"
    sha256 cellar: :any,                 arm64_monterey: "00164ffc2fe448cd629fb71d92d707519eb9f2a49df0f432d50d504af59b5a78"
    sha256 cellar: :any,                 ventura:        "17f32bca51cb6cec63c6c2fcba0346cbbc703bdf5fed5280db3416bdc8921306"
    sha256 cellar: :any,                 monterey:       "a408317630c4d8d9b787e5a53dc6d4332a0aeb98ce7213402a4aade66017dfef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56ff13484f743b7de168c758f888cd276967e28eff6840f969129dc35328ce6f"
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
