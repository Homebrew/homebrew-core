class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.47.2/meson-0.47.2.tar.gz"
  sha256 "92d8afd921751261e36151643464efd3394162f69efbe8cd53e0a66b1cf395eb"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a5289a130856e07683e63719af24b723876d53b8e66d50d117a959b4850a2d9" => :mojave
    sha256 "84505889d56e7a674ad755c2a10c0068436ba0cf85ae32aedf7e163ceb027ea5" => :high_sierra
    sha256 "84505889d56e7a674ad755c2a10c0068436ba0cf85ae32aedf7e163ceb027ea5" => :sierra
    sha256 "84505889d56e7a674ad755c2a10c0068436ba0cf85ae32aedf7e163ceb027ea5" => :el_capitan
  end

  depends_on "python"
  depends_on "ninja"

  def install
    version = Language::Python.major_minor_version("python3")
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"

    system "python3", *Language::Python.setup_install_args(prefix)

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"helloworld.c").write <<~EOS
      main() {
        puts("hi");
        return 0;
      }
    EOS
    (testpath/"meson.build").write <<~EOS
      project('hello', 'c')
      executable('hello', 'helloworld.c')
    EOS

    mkdir testpath/"build" do
      system "#{bin}/meson", ".."
      assert_predicate testpath/"build/build.ninja", :exist?
    end
  end
end
