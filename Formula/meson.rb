class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "http://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.42.0/meson-0.42.0.tar.gz"
  sha256 "a74c7387a3dd8171e931bcd948355f7f9529368eae72c3c22a9beef6c2e73498"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d9c7e3b50fed15323b120d6bbda4c69911736635af41ee1aa171810b6183849" => :sierra
    sha256 "1d9c7e3b50fed15323b120d6bbda4c69911736635af41ee1aa171810b6183849" => :el_capitan
    sha256 "1d9c7e3b50fed15323b120d6bbda4c69911736635af41ee1aa171810b6183849" => :yosemite
  end

  depends_on :python3
  depends_on "ninja"

  def install
    version = Language::Python.major_minor_version("python3")
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"

    system "python3", *Language::Python.setup_install_args(prefix)

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
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
