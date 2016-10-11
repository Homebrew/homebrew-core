class Meson < Formula
  include Language::Python::Virtualenv

  desc "Fast and user friendly build system"
  homepage "http://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.35.0/meson-0.35.0.tar.gz"
  sha256 "6e30bad3f819bf3930745a5b7da0abc4c3a767908b531d66a06177d0fae6ef00"
  head "https://github.com/mesonbuild/meson.git"
  revision 1

  bottle do
    sha256 "62def1bceba26bc2f05b561a1165173a19ba9c217484e1b6d22bd4d8352fe3f5" => :sierra
    sha256 "5fc4d819c174040c6047485b53e93761fd2947188c9d5963d0c434159f7581c2" => :el_capitan
    sha256 "d7626da017c4d43675e4ffaad03361691164e55b27ea3e0ecab1eb58aa76d4a4" => :yosemite
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
