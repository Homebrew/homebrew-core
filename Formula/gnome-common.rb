class GnomeCommon < Formula
  desc "Core files for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gnome-common"
  url "https://download.gnome.org/sources/gnome-common/3.18/gnome-common-3.18.0.tar.xz"
  sha256 "22569e370ae755e04527b76328befc4c73b62bfd4a572499fde116b8318af8cf"
  license "GPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f0301bdbf6c3d84a7c95e2ddc3c94a82ba79ac415a49e93b36a793dda8c02e34"
    sha256 cellar: :any_skip_relocation, big_sur:       "ff4e1b1395991ae955f575ed3529e66a881ada9561866b10030d00883b1ceab5"
    sha256 cellar: :any_skip_relocation, catalina:      "079756ae6ef88387933614b1adcd2a76f239f779817f6128493cdac85c8f5baa"
    sha256 cellar: :any_skip_relocation, mojave:        "7c853c9cdcd84eddb2a3567d161182b27b42dd28c2d696005dc43cf27bdb7038"
    sha256 cellar: :any_skip_relocation, high_sierra:   "e0d511e98b09eff8a4e0a0511b421459b4610516d643fc9094a44c9e480a7771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "186e36c90aadeb3fe96a17c685b1610b43ff5522d7cd4bad372d6f823938bb07"
    sha256 cellar: :any_skip_relocation, all:           "186e36c90aadeb3fe96a17c685b1610b43ff5522d7cd4bad372d6f823938bb07"
  end

  conflicts_with "autoconf-archive", because: "both install ax_check_enable_debug.m4 and ax_code_coverage.m4"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
