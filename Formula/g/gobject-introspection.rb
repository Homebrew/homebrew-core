class GobjectIntrospection < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Generate introspection data for GObject libraries"
  homepage "https://gi.readthedocs.io/en/latest/"
  url "https://download.gnome.org/sources/gobject-introspection/1.78/gobject-introspection-1.78.1.tar.xz"
  sha256 "bd7babd99af7258e76819e45ba4a6bc399608fe762d83fde3cac033c50841bb4"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later", "MIT"]

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "025018b9b268379c594d7a079ea585962a82610632f5fa7682347d7cdb031755"
    sha256 arm64_ventura:  "aeead3c8ba54d00e773d9140071a73c5736f5f20bc6c43b6483394da0e68eb98"
    sha256 arm64_monterey: "8d424f839195237aa9714ea4d5c10d79de2bd253a6b087a3e7f954f43d8b9f31"
    sha256 sonoma:         "f37f64f8ab0b15e72d0d026af7e0a1ef69bf26cd98d161c7a03db5ecd7ff13d8"
    sha256 ventura:        "e303113b7611e51e42ea3ea79675ec6cd9c4ad825c0273596bf1785a5a4af14e"
    sha256 monterey:       "b4f2b89603090bd8f9950b53ac5399c51ba1fde15cce6d4eb86ec79b91207e3c"
    sha256 x86_64_linux:   "236dac74f5dc88d7217ccabfdb17393ed6bb87ecc56ff5521ee55be41f574787"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "pkg-config"
  # Ships a `_giscanner.cpython-312-darwin.so`, so needs a specific version.
  depends_on "python@3.12"

  uses_from_macos "flex" => :build
  uses_from_macos "libffi", since: :catalina

  resource "mako" do
    url "https://files.pythonhosted.org/packages/d4/1b/71434d9fa9be1ac1bc6fb5f54b9d41233be2969f16be759766208f49f072/Mako-1.3.2.tar.gz"
    sha256 "2a0c8ad7f6274271b3bb7467dd37cf9cc6dab4bc19cb69a4ef10669402de698e"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/11/28/c5441a6642681d92de56063fa7984df56f783d3f1eba518dc3e7a253b606/Markdown-3.5.2.tar.gz"
    sha256 "e1ac7b3dc550ee80e602e71c1d168002f062e49f1b11e26a36264dafd4df2ef8"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4d/5b/dc575711b6b8f2f866131a40d053e30e962e633b332acf7cd2c24843d83d/setuptools-69.2.0.tar.gz"
    sha256 "0ff4183f8f42cd8fa3acea16c45205521a4ef28f73c6391d8a25e92893134f2e"
  end

  # Fix library search path on non-/usr/local installs (e.g. Apple Silicon)
  # See: https://github.com/Homebrew/homebrew-core/issues/75020
  #      https://gitlab.gnome.org/GNOME/gobject-introspection/-/merge_requests/273
  patch do
    url "https://gitlab.gnome.org/tschoonj/gobject-introspection/-/commit/a7be304478b25271166cd92d110f251a8742d16b.diff"
    sha256 "740c9fba499b1491689b0b1216f9e693e5cb35c9a8565df4314341122ce12f81"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resources
    ENV.prepend_path "PATH", venv.root/"bin"

    ENV["GI_SCANNER_DISABLE_CACHE"] = "true"

    inreplace "giscanner/transformer.py", "/usr/share", "#{HOMEBREW_PREFIX}/share"
    inreplace "meson.build",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', join_paths(get_option('prefix'), get_option('libdir')))",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', '#{HOMEBREW_PREFIX}/lib')"

    system "meson", "setup", "build", "-Dpython=#{venv.root}/bin/python",
                                      "-Dextra_library_paths=#{HOMEBREW_PREFIX}/lib",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    rewrite_shebang python_shebang_rewrite_info(venv.root/"bin/python"), *bin.children
  end

  test do
    resource "homebrew-tutorial" do
      url "https://gist.github.com/tdsmith/7a0023656ccfe309337a.git",
          revision: "499ac89f8a9ad17d250e907f74912159ea216416"
    end

    resource("homebrew-tutorial").stage testpath
    system "make"
    assert_predicate testpath/"Tut-0.1.typelib", :exist?
  end
end
