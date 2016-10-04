class Meson < Formula
  include Language::Python::Virtualenv

  desc "Fast and user friendly build system"
  homepage "http://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.35.0/meson-0.35.0.tar.gz"
  sha256 "6e30bad3f819bf3930745a5b7da0abc4c3a767908b531d66a06177d0fae6ef00"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "78fdb388a133aebdc3a30cbb297539a46830963148c57dfb6054e53991d53fe7" => :sierra
    sha256 "47f37b582826aacd39b3000523b8fdfea87d5f35aa58ac6ce96fdfcd41cc1dcd" => :el_capitan
    sha256 "2c9de47261bdaf0f10fd995caa3e5bbf7da14876e7295096ccab9f8212047f68" => :yosemite
    sha256 "2c9de47261bdaf0f10fd995caa3e5bbf7da14876e7295096ccab9f8212047f68" => :mavericks
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
