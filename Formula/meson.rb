class Meson < Formula
  include Language::Python::Virtualenv

  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.62.1/meson-0.62.1.tar.gz"
  sha256 "a0f5caa1e70da12d5e63aa6a9504273759b891af36c8d87de381a4ed1380e845"
  license "Apache-2.0"
  head "https://github.com/mesonbuild/meson.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "830d3c82402a695a246c92500f6a07fafc39e8382b1d8d4c133454e39a0b90ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a10859243b1637c4aa49ace9b8c403198855565c15f655c3b9b7835b4d2f05b6"
    sha256 cellar: :any_skip_relocation, monterey:       "a7630ba31e6fa29ee38900eb363b3969197cc6f35504d1fdfb06904f034aff9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "33a4c7a19baff6923d73296481feee3612b8b947da2756152d3800a5d65d4686"
    sha256 cellar: :any_skip_relocation, catalina:       "070b11813bca11380b90b942aa55f5bd641a13745a63da530827381dd8dca462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd1a7dd039cd225448769fc2dc81b0b7ed2b5da61b76fdce95cb1a20e6e35ec6"
  end

  depends_on "ninja"
  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
    bash_completion.install "data/shell-completions/bash/meson"
    zsh_completion.install "data/shell-completions/zsh/_meson"
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
      system bin/"meson", ".."
      assert_predicate testpath/"build/build.ninja", :exist?
    end
  end
end
