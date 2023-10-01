class GobjectIntrospection < Formula
  include Language::Python::Shebang

  desc "Generate introspection data for GObject libraries"
  homepage "https://gi.readthedocs.io/en/latest/"
  url "https://download.gnome.org/sources/gobject-introspection/1.78/gobject-introspection-1.78.1.tar.xz"
  sha256 "bd7babd99af7258e76819e45ba4a6bc399608fe762d83fde3cac033c50841bb4"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later", "MIT"]

  bottle do
    sha256 arm64_sonoma:   "8c547b892852c7cafde84c3e989f714c0f189af50befd5a93a7919d050a15f61"
    sha256 arm64_ventura:  "b2b4e8d3b3b30033357e861bd749f55dfce23407523dfadbbcf14c990ef3dd06"
    sha256 arm64_monterey: "7daa626f4da8e5e89c28198306750465c0e95375482541686a2a3913bf0eb04a"
    sha256 arm64_big_sur:  "59c6c1ee9ead7d4403daabf43de79ec6121fb9f4c2ac641df9fdde96b35de637"
    sha256 sonoma:         "a616c6b151680047519187262245cb27a9ce45b99c17df34f850116be404d559"
    sha256 ventura:        "96eb66715ded9f4e5a9d586b4e0a60a8332181068cb736b97e576eb75cf35026"
    sha256 monterey:       "c46f507049bab04bb165da06d7d6461d3f048beadec763f9b773f677435a7d6d"
    sha256 big_sur:        "f29fd2b664e44c6054cb60a1259fed95244e8b4404ab9e95246d900fdc214da7"
    sha256 x86_64_linux:   "d2d964476da6d9e5cfd0831513566250ec3bdf071ddfa7a1aafca49e6b740c3e"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "pkg-config"
  # Ships a `_giscanner.cpython-311-darwin.so`, so needs a specific version.
  depends_on "python@3.11"

  uses_from_macos "flex" => :build
  uses_from_macos "libffi", since: :catalina

  # Fix library search path on non-/usr/local installs (e.g. Apple Silicon)
  # See: https://github.com/Homebrew/homebrew-core/issues/75020
  #      https://gitlab.gnome.org/GNOME/gobject-introspection/-/merge_requests/273
  patch do
    url "https://gitlab.gnome.org/tschoonj/gobject-introspection/-/commit/a7be304478b25271166cd92d110f251a8742d16b.diff"
    sha256 "740c9fba499b1491689b0b1216f9e693e5cb35c9a8565df4314341122ce12f81"
  end

  def python3
    which("python3.11")
  end

  def install
    ENV["GI_SCANNER_DISABLE_CACHE"] = "true"

    inreplace "giscanner/transformer.py", "/usr/share", "#{HOMEBREW_PREFIX}/share"
    inreplace "meson.build",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', join_paths(get_option('prefix'), get_option('libdir')))",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', '#{HOMEBREW_PREFIX}/lib')"

    system "meson", "setup", "build", "-Dpython=#{python3}",
                                      "-Dextra_library_paths=#{HOMEBREW_PREFIX}/lib",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    rewrite_shebang detected_python_shebang, *bin.children
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
