class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/1.2.2/meson-1.2.2.tar.gz"
  sha256 "4a0f04de331fbc7af3b802a844fc8838f4ccd1ded1e792ba4f8f2faf8c5fe4d6"
  license "Apache-2.0"
  head "https://github.com/mesonbuild/meson.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "4b8fa8d6f17e912e96e3ad43475f44c3ba3ce8c5a43e45f8ea03b52fc517d797"
  end

  depends_on "python-setuptools" => :build
  depends_on "ninja"
  depends_on "python@3.12"

  def install
    python = "python3.12"
    system python, *Language::Python.setup_install_args(prefix, python), "--install-data=#{prefix}"

    bash_completion.install "data/shell-completions/bash/meson"
    zsh_completion.install "data/shell-completions/zsh/_meson"
    vim_plugin_dir = buildpath/"data/syntax-highlighting/vim"
    (share/"vim/vimfiles").install %w[ftdetect ftplugin indent syntax].map { |dir| vim_plugin_dir/dir }

    # Make the bottles uniform. This also ensures meson checks `HOMEBREW_PREFIX`
    # for fulfilling dependencies rather than just `/usr/local`.
    mesonbuild = prefix/Language::Python.site_packages(python)/"mesonbuild"
    inreplace_files = %w[
      coredata.py
      dependencies/boost.py
      dependencies/cuda.py
      dependencies/qt.py
      scripts/python_info.py
      utils/universal.py
    ].map { |f| mesonbuild/f }
    inreplace_files << (bash_completion/"meson")

    # Passing `build.stable?` ensures a failed `inreplace` won't fail HEAD installs.
    inreplace inreplace_files, "/usr/local", HOMEBREW_PREFIX, build.stable?
  end

  test do
    (testpath/"helloworld.c").write <<~EOS
      #include <stdio.h>
      main() {
        puts("hi");
        return 0;
      }
    EOS
    (testpath/"meson.build").write <<~EOS
      project('hello', 'c')
      executable('hello', 'helloworld.c')
    EOS

    system bin/"meson", "setup", "build"
    assert_predicate testpath/"build/build.ninja", :exist?

    system bin/"meson", "compile", "-C", "build", "--verbose"
    assert_equal "hi", shell_output("build/hello").chomp
  end
end
