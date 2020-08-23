class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.55.1/meson-0.55.1.tar.gz"
  sha256 "3b5741f884e04928bdfa1947467ff06afa6c98e623c25cef75adf71ca39ce080"
  license "Apache-2.0"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad63598f734e071dcaff8e1294bf4bdc7f4e3c6d76e5b32a9d1016aea96fb808" => :catalina
    sha256 "ad63598f734e071dcaff8e1294bf4bdc7f4e3c6d76e5b32a9d1016aea96fb808" => :mojave
    sha256 "ad63598f734e071dcaff8e1294bf4bdc7f4e3c6d76e5b32a9d1016aea96fb808" => :high_sierra
  end

  depends_on "ninja"
  depends_on "python@3.8"

  def install
    version = Language::Python.major_minor_version Formula["python@3.8"].bin/"python3"
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"

    system Formula["python@3.8"].bin/"python3", *Language::Python.setup_install_args(prefix)

    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
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
