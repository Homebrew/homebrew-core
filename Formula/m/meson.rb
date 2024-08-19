class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/1.5.1/meson-1.5.1.tar.gz"
  sha256 "567e533adf255de73a2de35049b99923caf872a455af9ce03e01077e0d384bed"
  license "Apache-2.0"
  head "https://github.com/mesonbuild/meson.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "538ebaeac79dccff22a262d09fa590f7e538ea24928f4a35142485e3c3feea80"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "538ebaeac79dccff22a262d09fa590f7e538ea24928f4a35142485e3c3feea80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "538ebaeac79dccff22a262d09fa590f7e538ea24928f4a35142485e3c3feea80"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e54fd61d7161717c0ef89dad36a82423e5bbbfb1cbf94eb7ade6f6a0c8e4b0a"
    sha256 cellar: :any_skip_relocation, ventura:        "1e54fd61d7161717c0ef89dad36a82423e5bbbfb1cbf94eb7ade6f6a0c8e4b0a"
    sha256 cellar: :any_skip_relocation, monterey:       "1e54fd61d7161717c0ef89dad36a82423e5bbbfb1cbf94eb7ade6f6a0c8e4b0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4941b3900a433dacad331eb52ba809f45dd3e439e19eb150ae442eebe9bcb3f"
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
