class Fdupes < Formula
  desc "Identify or delete duplicate files"
  homepage "https://github.com/adrianlopezroche/fdupes"
  url "https://github.com/adrianlopezroche/fdupes/releases/download/v2.4.0/fdupes-2.4.0.tar.gz"
  sha256 "527b27a39d031dcbe1d29a220b3423228c28366c2412887eb72c25473d7b1736"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ddc93ce12edb258a3c40cf832cec446cb77483028cfb8c57f3d06c35f5069ce2"
    sha256 cellar: :any,                 arm64_sequoia: "b54e8a104cb80b26e7f00a6dc9cf338184c1649f4f0b21184d80a14c929e4cd7"
    sha256 cellar: :any,                 arm64_sonoma:  "119d17b7629a8a93cd3a8df4705dace6ff5aa48aa579335c39388ceb429876ab"
    sha256 cellar: :any,                 arm64_ventura: "1aacfa4639b04ac0818c34e93f90ea27d4088b1ea565754f0df2d1d288be3b2d"
    sha256 cellar: :any,                 sonoma:        "8c26915d4b44002eee78f4e086321179cc64df583861a2aeb8ad231d8871a431"
    sha256 cellar: :any,                 ventura:       "284f3172305b2a50293c69bd760d65007611557e771a5980a6e5bef3da419a9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f60e326d0f15119154f435b3b9108bfe5c84f1fe3b117fa540c970b69b5d264e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01d6962c47feccfa20d92e25b33081ee93c121042e98898fdf73081551239cc9"
  end

  depends_on "pcre2"

  uses_from_macos "ncurses"
  uses_from_macos "sqlite"

  def install
    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make"
    system "make", "install"
  end

  test do
    touch "a"
    touch "b"

    dupes = shell_output("#{bin}/fdupes .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
