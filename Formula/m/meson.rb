class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/1.4.1/meson-1.4.1.tar.gz"
  sha256 "1b8aad738a5f6ae64294cc8eaba9a82988c1c420204484ac02ef782e5bba5f49"
  license "Apache-2.0"
  head "https://github.com/mesonbuild/meson.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5cb4ca07916a11d1a515f0981b08cda66e2cce2511595166ccb98ea0ad940b33"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5cb4ca07916a11d1a515f0981b08cda66e2cce2511595166ccb98ea0ad940b33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cb4ca07916a11d1a515f0981b08cda66e2cce2511595166ccb98ea0ad940b33"
    sha256 cellar: :any_skip_relocation, sonoma:         "16f8e1771b5b44f4474a69129d92950d0e65b16daa71b388506f4443423d4b4e"
    sha256 cellar: :any_skip_relocation, ventura:        "16f8e1771b5b44f4474a69129d92950d0e65b16daa71b388506f4443423d4b4e"
    sha256 cellar: :any_skip_relocation, monterey:       "16f8e1771b5b44f4474a69129d92950d0e65b16daa71b388506f4443423d4b4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abcd020d22b9479e9c7148fb586b4df7ac17a36569ca0e79e2db7c3930310851"
  end

  depends_on "ninja"
  depends_on "python@3.12"

  def install
    python3 = "python3.12"
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."

    bash_completion.install "data/shell-completions/bash/meson"
    zsh_completion.install "data/shell-completions/zsh/_meson"
    vim_plugin_dir = buildpath/"data/syntax-highlighting/vim"
    (share/"vim/vimfiles").install %w[ftdetect ftplugin indent syntax].map { |dir| vim_plugin_dir/dir }

    # Make the bottles uniform. This also ensures meson checks `HOMEBREW_PREFIX`
    # for fulfilling dependencies rather than just `/usr/local`.
    mesonbuild = prefix/Language::Python.site_packages(python3)/"mesonbuild"
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
      int main(void) {
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
