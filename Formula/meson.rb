class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.50.1/meson-0.50.1.tar.gz"
  sha256 "f68f56d60c80a77df8fc08fa1016bc5831605d4717b622c96212573271e14ecc"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9192148d229035b4c6241d302aa612a14d8e875f567fad5e1579c68388fa6e24" => :mojave
    sha256 "9192148d229035b4c6241d302aa612a14d8e875f567fad5e1579c68388fa6e24" => :high_sierra
    sha256 "e3c2a08602674e703b622e2df8d8dc9a1444dc30d57ad8007c8d28564fc24a0d" => :sierra
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
