class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "http://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.39.0/meson-0.39.0.tar.gz"
  sha256 "e582b040038d6ae7c44e64eda05bc24e0a9328629a82c3e4c2bfb983eade7592"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "da259014ed2ca94079417516dd93b0381d4df6147546e3fda1bd5322249620d5" => :sierra
    sha256 "da259014ed2ca94079417516dd93b0381d4df6147546e3fda1bd5322249620d5" => :el_capitan
    sha256 "da259014ed2ca94079417516dd93b0381d4df6147546e3fda1bd5322249620d5" => :yosemite
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
