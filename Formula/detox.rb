class Detox < Formula
  desc "Utility to replace problematic characters in filenames"
  homepage "https://detox.sourceforge.io/"
  url "https://github.com/dharple/detox/archive/v1.4.1.tar.gz"
  sha256 "fd71aa31abc82b1ec8b7ce996cd70062939e9c165b106f395beced3706c5ea17"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "34f21ef616c1eeebc74b3d19186db6098de4bc3ba45a9d33aceb17a7c5e385b4"
    sha256 big_sur:       "de36bde95c7afcafc38f9600cbf0a5eaadb6df1ccdd9c9b3dc64ce2c7afd3637"
    sha256 catalina:      "42864935039463dd2f989f4e2010015a5f18f1ae61beeaf86c7daae19b8e6da8"
    sha256 mojave:        "f8595a0409549a8a7726f03d4f8d46de29e4c1f79f8091c6c9e19bf20cb77798"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--mandir=#{man}", "--prefix=#{prefix}"
    system "make"
    (prefix/"etc").mkpath
    pkgshare.mkpath
    system "make", "install"
  end

  test do
    (testpath/"rename this").write "foobar"
    assert_equal "rename this -> rename_this\n", shell_output("#{bin}/detox --dry-run rename\\ this")
  end
end
