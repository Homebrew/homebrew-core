class MesonInternal < Formula
  include Language::Python::Virtualenv

  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.46.1/meson-0.46.1.tar.gz"
  sha256 "19497a03e7e5b303d8d11f98789a79aba59b5ad4a81bd00f4d099be0212cee78"
  license "Apache-2.0"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "2081b7b2d37614f170b2b55855d77bd2788922a02103da66f2d0d33952541a3f" => :catalina
    sha256 "c00f702a075153263b34ade26d43a9a3a98673b6b8d30ce7d17e36581b16f2bf" => :mojave
    sha256 "e5c4655a955250b17edc8fbd17a3bd56b5a99d1fc34db303f2bfa684a2c76167" => :high_sierra
  end

  keg_only <<~EOS
    this formula contains a heavily patched version of the meson build system and
    is exclusively used internally by other formulae.
    Users are advised to run `brew install meson` to install
    the official meson build
  EOS

  depends_on "ninja"
  depends_on "python@3.8"

  # see https://github.com/mesonbuild/meson/pull/2577
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/a20d7df94112f93ea81f72ff3eacaa2d7e681053/meson-internal/meson-osx.patch?full_index=1"
    sha256 "d8545f5ffbb4dcc58131f35a9a97188ecb522c6951574c616d0ad07495d68895"
  end

  def install
    virtualenv_install_with_resources
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
