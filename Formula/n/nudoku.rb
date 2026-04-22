class Nudoku < Formula
  desc "Ncurses based sudoku game"
  homepage "https://jubalh.github.io/nudoku/"
  url "https://github.com/jubalh/nudoku/archive/refs/tags/8.0.0.tar.gz"
  sha256 "061ef63cd4754e22024fbfbc5fc103de9e4a90ffe21790a3433c8af770e6da09"
  license "GPL-3.0-or-later"
  head "https://github.com/jubalh/nudoku.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "23f852beb2766426f9b5126d34fa384045387c4c8ffcadc6ca2ed5fb6a7780c5"
    sha256 cellar: :any, arm64_sequoia: "23fbd7ad2727a862d6fa8b8a6ed458bf7ec973d9b319f3d56f8a31c038632544"
    sha256 cellar: :any, arm64_sonoma:  "9de871a41e93c471d24c2ee3a4be9e5502c03147c282ab1f8ec96c02f42feab4"
    sha256 cellar: :any, sonoma:        "2e0303165131c4e483fea029ca68c3dc16fd991201b4c314a257584faeed2569"
    sha256               arm64_linux:   "aa24c19f9bc4d7d9802023cf1fabf721f4fdb4dc88b9ddecab412a4927a7ec55"
    sha256               x86_64_linux:  "abce8638e046b755c3d568808a022e7b0c74689e55c6b98f54e1d14bdc58424f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

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
