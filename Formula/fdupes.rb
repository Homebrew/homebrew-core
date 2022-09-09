class Fdupes < Formula
  desc "Identify or delete duplicate files"
  homepage "https://github.com/adrianlopezroche/fdupes"
  url "https://github.com/adrianlopezroche/fdupes/releases/download/v2.2.1/fdupes-2.2.1.tar.gz"
  sha256 "846bb79ca3f0157856aa93ed50b49217feb68e1b35226193b6bc578be0c5698d"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a1fc7d71f6632a3f5834879a779fc7ccafa0db774d0c81c3f89fb0d681c02c63"
    sha256 cellar: :any,                 arm64_big_sur:  "eb9f43bdca634ab81e9ddff72fd0f655b64ff5753282c0fd9b1b53b444011964"
    sha256 cellar: :any,                 monterey:       "ec9f3a94a3a9641b86617079f7aa7b82add0119243056f17fbe72a52bb4a8be2"
    sha256 cellar: :any,                 big_sur:        "daa6cc796f0e23e9a1dfcf0aa11f26256bd29cca18cf0b1ec6650cc6437f8ba0"
    sha256 cellar: :any,                 catalina:       "2ce9b07941034c8561e1413eab622365b38a61af392e39b4a81b5f06c9a2ab8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "554c0c847b443ea673afa9d04a5e799d091291a6347ed46b33b6ff24306d28a2"
  end

  depends_on "pcre2"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}"
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
