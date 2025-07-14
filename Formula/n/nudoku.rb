class Nudoku < Formula
  desc "Ncurses based sudoku game"
  homepage "https://jubalh.github.io/nudoku/"
  url "https://github.com/jubalh/nudoku/archive/refs/tags/5.0.0.tar.gz"
  sha256 "ba60a99c9832b5c950a00a0a9d1e0938fddf2cef32765bca18041e770afc3c4a"
  license "GPL-3.0-or-later"
  head "https://github.com/jubalh/nudoku.git", branch: "master"

  bottle do
    sha256 arm64_sequoia:  "f829eb3b002dc33ea48c3d58926a3ca3c5a0378941ce0b587737d4ed1a11a100"
    sha256 arm64_sonoma:   "969ddf28f4eb7014b9c44cf6bac0106f2d00306fef670f08b8d57fa08873ca9f"
    sha256 arm64_ventura:  "8e257d6a76e89ded708920215a7446a845c2ed74fe1cb31ee695de5f08129864"
    sha256 arm64_monterey: "ad835249ee203dac6d4c7fdd7b95d1395e113f6aaa0ec7a4d2d14c9405e61cc3"
    sha256 sonoma:         "d4f87f815b143cddae90e6bcf12bb8609a53e7f112cb19580585613e92a2fd49"
    sha256 ventura:        "a58e28aa1ffac9ef8d792ef34190e7bd1605828aa2ae29550042e28740863023"
    sha256 monterey:       "c208d8a2b1a5bbe9179a4969f284e2412ad354ee00da078f423552adc67698fa"
    sha256 arm64_linux:    "b91300e0ac30944be3a94ba767f3ee11aff11ed7fd41f7987b0d9195989a2fef"
    sha256 x86_64_linux:   "6050f8f3ab9a15cafee9cf73e62cfc236bd98f445015cbed8f2a48fb82de0efc"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "gettext"

  uses_from_macos "ncurses"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules",
                          "--enable-cairo",
                          *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "nudoku version #{version}", shell_output("#{bin}/nudoku -v")
  end
end
