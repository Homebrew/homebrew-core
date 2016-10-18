class Meson < Formula
  include Language::Python::Virtualenv

  desc "Fast and user friendly build system"
  homepage "http://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.35.1/meson-0.35.1.tar.gz"
  sha256 "b47edb53bd7554cb7890a32399fdf6402e8079379393893ab3dec8fffcbfba2c"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    sha256 "deaa7f68ec76ab735db033eb36f221773d40c8d765c8ce4f9b74cecaf9e6ebeb" => :sierra
    sha256 "619a7f794cb82dc70a7cc9fe0f1ae9ff7554e3b377de566042f4c49cb881a125" => :el_capitan
    sha256 "82d76b4433508510850043c4aff6ce342eb221e6ac7f1732fa02fed39b744b30" => :yosemite
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
