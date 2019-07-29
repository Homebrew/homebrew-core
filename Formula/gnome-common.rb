class GnomeCommon < Formula
  desc "Core files for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gnome-common"
  url "https://download.gnome.org/sources/gnome-common/3.18/gnome-common-3.18.0.tar.xz"
  sha256 "22569e370ae755e04527b76328befc4c73b62bfd4a572499fde116b8318af8cf"

  bottle do
    cellar :any_skip_relocation
    sha256 "abae5e0fbfb6d9995ca705f512c606efc426b17e0aee0e323f62bdb6daebdcf6" => :mojave
    sha256 "1a24d488923e1d73f30e541bf1fcd4956d73e4d0f11c32e5133946cb6a1c546b" => :high_sierra
    sha256 "6aae778f648ed18eb63e49a5764fa98431683dcaff1d42280d9cdd464b727312" => :sierra
    sha256 "a5ad22711bdc05e9dbe4c4891ad06f146bc81b4d0d7d737d582f32e36f4e6fc7" => :el_capitan
    sha256 "7e3512e3a7c39f759ab9f3642831961b355f3f83ae6e19a26fdaf91739870e23" => :yosemite
    sha256 "a96e5dedc2888b6caa326da0abd8eb7d3f1426407e8bef82a6ba0f41adb7016a" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
