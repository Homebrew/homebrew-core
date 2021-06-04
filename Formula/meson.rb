class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.58.0/meson-0.58.0.tar.gz"
  sha256 "f4820df0bc969c99019fd4af8ca5f136ee94c63d8a5ad67e7eb73bdbc9182fdd"
  license "Apache-2.0"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c1fba0086aeee0b00dfa35e9be8153e11b1f0ba42723629d2e1f1b99f2738a44"
    sha256 cellar: :any_skip_relocation, big_sur:       "78350d37831bed52c7a07607a74e991f968b39c7b81edb1a6365bba575990da5"
    sha256 cellar: :any_skip_relocation, catalina:      "78350d37831bed52c7a07607a74e991f968b39c7b81edb1a6365bba575990da5"
    sha256 cellar: :any_skip_relocation, mojave:        "78350d37831bed52c7a07607a74e991f968b39c7b81edb1a6365bba575990da5"
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
