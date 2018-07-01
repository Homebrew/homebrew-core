class MesonInternal < Formula
  include Language::Python::Virtualenv

  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.45.1/meson-0.45.1.tar.gz"
  sha256 "4d0bb0dbb1bb556cb7a4092fdfea3d6e76606bd739a4bc97481c2d7bc6200afb"
  revision 1
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6956ee4990e80aca5f028a80f96f8f6b240ebb065d26840e1506d3c92ab015f2" => :high_sierra
    sha256 "6791d27d9dda96d770282696cab95635b949caa47937495ab3b560f9da5b73f3" => :sierra
    sha256 "bcdf452afbe4f9d5917c9db5af9931c366c91c9c027bc5776d75421581c8122f" => :el_capitan
  end

  keg_only <<~EOS
    this formula contains a heavily patched version of the meson build system and
    is exclusively used internally by other formulae.
    Users are advised to run `brew install meson` to install
    the official meson build
  EOS

  depends_on "ninja"
  depends_on "python"

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
