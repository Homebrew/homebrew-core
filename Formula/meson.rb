class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.53.2/meson-0.53.2.tar.gz"
  sha256 "3e8f830f33184397c2eb0b651ec502adb63decb28978bdc84b3558d71284c21f"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2855c6300305417e6b709f9f4a197b6b9905255d947dd8263b14443c18a64a6" => :catalina
    sha256 "b2855c6300305417e6b709f9f4a197b6b9905255d947dd8263b14443c18a64a6" => :mojave
    sha256 "b2855c6300305417e6b709f9f4a197b6b9905255d947dd8263b14443c18a64a6" => :high_sierra
  end

  depends_on "ninja"
  depends_on "python"

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
