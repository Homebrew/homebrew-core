class Gauche < Formula
  desc "R7RS Scheme implementation, developed to be a handy script interpreter"
  homepage "https://practical-scheme.net/gauche/"
  url "https://github.com/shirok/Gauche/releases/download/release0_9_12/Gauche-0.9.12.tgz"
  sha256 "b4ae64921b07a96661695ebd5aac0dec813d1a68e546a61609113d7843f5b617"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(/href=.*?Gauche[._-]v?(\d+(?:\.\d+)+(?:[._-]p\d+)?)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "4bdf5a2a9587084ab420015aa4587ec327ee3f05506a884d742ef71cf10ea7dd"
    sha256 arm64_big_sur:  "dbeda7059ccccad0efd5d615ba0f36fe0b5160d180d131149970428ae409672b"
    sha256 monterey:       "a0b4f07a8397f91ef11b66d215e5c18eca3b7b0da67b47117a20a7730cd5df5d"
    sha256 big_sur:        "2a21e02ce609480efec6abc2e9f03e9bd4cf1f353c132783101ead0a5ce219d8"
    sha256 catalina:       "7f9f718aac4ec5c52ef60b3338c43204fa3ab019446f834867a5d528611b4583"
    sha256 x86_64_linux:   "31295606e5b3844e9c3c3d999853236eef698250a415f3209083421a0dc36964"
  end

  depends_on "mbedtls"

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args,
                          "--enable-multibyte=utf-8"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/gosh -V")
    assert_match "Gauche scheme shell, version #{version}", output
  end
end
