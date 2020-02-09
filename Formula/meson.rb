class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.53.1/meson-0.53.1.tar.gz"
  sha256 "ec1ba33eea701baca2c1607dac458152dc8323364a51fdef6babda2623413b04"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "654493ead6ed51ec7327000050005b3bb64ebcee973707082e760da4a641950d" => :catalina
    sha256 "654493ead6ed51ec7327000050005b3bb64ebcee973707082e760da4a641950d" => :mojave
    sha256 "654493ead6ed51ec7327000050005b3bb64ebcee973707082e760da4a641950d" => :high_sierra
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
