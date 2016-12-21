class Meson < Formula
  include Language::Python::Virtualenv

  desc "Fast and user friendly build system"
  homepage "http://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.37.1/meson-0.37.1.tar.gz"
  sha256 "72516e25eaf9efd67fe8262ccba05e1e84731cc139101fcda7794aed9f68f55a"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    sha256 "a31dbd10da782783daeae42a52b62e7c687e20321a4021e3e79affc71e98a2f3" => :sierra
    sha256 "c60d3b07fd3c1ba38d1f1cbb2b7aafae3c5565396691f5552574b675267d5aaa" => :el_capitan
    sha256 "79db25399a887e2c55a56002ed9ac84f9caea0006f9b36d04f760f3140768de6" => :yosemite
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
