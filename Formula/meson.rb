class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "http://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.34.0/meson-0.34.0.tar.gz"
  sha256 "e8cdc1847c615c53bd845163a46785e88c4c093b941ba4cb5cac76854769011f"
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
    version = Language::Python.major_minor_version("python3")
    ENV["PYTHONPATH"] = lib+"python#{version}/site-packages"

    system "python3", *Language::Python.setup_install_args(prefix)

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
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
