class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.54.3/meson-0.54.3.tar.gz"
  sha256 "f2bdf4cf0694e696b48261cdd14380fb1d0fe33d24744d8b2df0c12f33ebb662"
  license "Apache-2.0"
  revision 1
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7f74e33b1d750fe1ae058a507fb029a2b01d94cafdad0c87ccd04de478f3e40" => :catalina
    sha256 "6cfc8a50d28eb418dd6c203ffba8554e530a09f84d7376c33080b5b9e5286b01" => :mojave
    sha256 "e7f74e33b1d750fe1ae058a507fb029a2b01d94cafdad0c87ccd04de478f3e40" => :high_sierra
  end

  depends_on "ninja"
  depends_on "python@3.8"

  def install
    version = Language::Python.major_minor_version Formula["python@3.8"].bin/"python3"
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"

    system Formula["python@3.8"].bin/"python3", *Language::Python.setup_install_args(prefix)

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
