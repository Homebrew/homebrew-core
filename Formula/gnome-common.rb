class GnomeCommon < Formula
  desc "Core files for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gnome-common"
  url "https://download.gnome.org/sources/gnome-common/3.18/gnome-common-3.18.0.tar.xz"
  sha256 "22569e370ae755e04527b76328befc4c73b62bfd4a572499fde116b8318af8cf"
  license "GPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "079756ae6ef88387933614b1adcd2a76f239f779817f6128493cdac85c8f5baa" => :catalina
    sha256 "7c853c9cdcd84eddb2a3567d161182b27b42dd28c2d696005dc43cf27bdb7038" => :mojave
    sha256 "e0d511e98b09eff8a4e0a0511b421459b4610516d643fc9094a44c9e480a7771" => :high_sierra
  end

  conflicts_with "autoconf-archive", because: "both install ax_check_enable_debug.m4 and ax_code_coverage.m4"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
