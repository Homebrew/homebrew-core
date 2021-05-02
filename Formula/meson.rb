class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.58.0/meson-0.58.0.tar.gz"
  sha256 "f4820df0bc969c99019fd4af8ca5f136ee94c63d8a5ad67e7eb73bdbc9182fdd"
  license "Apache-2.0"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c171744d3de35b3b4935e0d2b918c79faae9410079efe0400369972110c39011"
    sha256 cellar: :any_skip_relocation, big_sur:       "3fd9a5a91ab780ebaf09c64e36bb7f02cb84f4cf4ae7a98815879e18b0aa5870"
    sha256 cellar: :any_skip_relocation, catalina:      "1bd8c87ac7fe8e3cf2063cba40675daa4606430c72b3fa10c5e83e77c26d45b8"
    sha256 cellar: :any_skip_relocation, mojave:        "c4c1a98009e36c835854133fc4ffd87afcc5510c9df63714366395204fc66391"
  end

  depends_on "ninja"
  depends_on "python@3.9"

  def install
    version = Language::Python.major_minor_version Formula["python@3.9"].bin/"python3"
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"

    system Formula["python@3.9"].bin/"python3", *Language::Python.setup_install_args(prefix)

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
