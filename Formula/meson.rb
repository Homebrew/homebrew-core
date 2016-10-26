class Meson < Formula
  include Language::Python::Virtualenv

  desc "Fast and user friendly build system"
  homepage "http://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.35.1/meson-0.35.1.tar.gz"
  sha256 "b47edb53bd7554cb7890a32399fdf6402e8079379393893ab3dec8fffcbfba2c"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    sha256 "8cf2a53fe4eac6e30170cbfc5ec4641eb023227d16ff9a3370af91e80dc2dba4" => :sierra
    sha256 "6519e09c6312b6614b49d58ab8cd84efe1a40fe4d8ee1a9184e01ff582c0b72b" => :el_capitan
    sha256 "d51800904d6b79eabdb31acdf27a4bb7947e4fb956d58da9fd0562d9764f9371" => :yosemite
  end

  depends_on :python3
  depends_on "ninja"

  def install
    virtualenv_create(libexec, "python3")
    virtualenv_install_with_resources
  end

  test do
    (testpath/"helloworld.c").write <<-EOS.undent
      main() {
        puts("hi");
        return 0;
      }
    EOS
    (testpath/"meson.build").write <<-EOS.undent
      project('hello', 'c')
      executable('hello', 'helloworld.c')
    EOS

    mkdir testpath/"build" do
      system "#{bin}/meson.py", ".."
      assert File.exist?(testpath/"build/build.ninja")
    end
  end
end
