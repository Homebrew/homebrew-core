class Meson < Formula
  include Language::Python::Virtualenv

  desc "Fast and user friendly build system"
  homepage "http://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.36.0/meson-0.36.0.tar.gz"
  sha256 "dc087ec40dacb5e256e6ee6467f2d004faf4ef284d3c1ce5e89faa1e16540950"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    sha256 "9c811cfec8ebbd6130228062ef6a6f6ee580c1db1299444cb95b728db7a5facc" => :sierra
    sha256 "84ec60b0c9cdbaba7b4ef2a77fad0f1ea5cabdc68f048ae5be261b08fc8951ca" => :el_capitan
    sha256 "0ef9720b2a145aed63063a2b4512a1add84b9a5954ad62e03c82258fcf5b6234" => :yosemite
  end

  depends_on :python3
  depends_on "ninja"

  def install
    virtualenv_install_with_resources
    inreplace bin/"meson", "#!/usr/bin/env python3", "#!#{libexec}/bin/python3"
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
      system "#{bin}/meson", ".."
      assert File.exist?(testpath/"build/build.ninja")
    end
  end
end
