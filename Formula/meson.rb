class Meson < Formula
  include Language::Python::Virtualenv

  desc "Fast and user friendly build system"
  homepage "http://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.37.1/meson-0.37.1.tar.gz"
  sha256 "72516e25eaf9efd67fe8262ccba05e1e84731cc139101fcda7794aed9f68f55a"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    sha256 "a016d4a0e2b89246aceadadfcd5b959807304a70041dde101ff7a92039ee51a7" => :sierra
    sha256 "bba9d4cfaaa9761847beaa803fe75b9f6024ef1a2fe1353f375081578fbd5032" => :el_capitan
    sha256 "35bea5594acdfaa00b8373e24e6614ee1b6755f5268c11fc9a056ff54ea03bd9" => :yosemite
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
