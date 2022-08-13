class Meson < Formula
  include Language::Python::Virtualenv

  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.63.1/meson-0.63.1.tar.gz"
  sha256 "06fe13297213d6ff0121c5d5aab25a56ef938ffec57414ed6086fda272cb65e9"
  license "Apache-2.0"
  head "https://github.com/mesonbuild/meson.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bda96a21f30e861534c318ebfa80dde210b333b20b95b486933bb3c45f85fc2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "569c7039b05c60513ff780ae8d0183b48304fce107ebff09000cec917ad3dd06"
    sha256 cellar: :any_skip_relocation, monterey:       "fbfee5b3ea83512e6860b7d857356b55548470cd52ede5d8232fab47cf5bb2d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "293976403ccb2e0e69aabda08bd3d4706cd6af64baced3293ff17b6728dbc2ae"
    sha256 cellar: :any_skip_relocation, catalina:       "ef87988b46ed85ff7790c2f286e19da4382e687cf7056dbceb9c7b4ad11d6075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22d3c30f3abe269394f8061af09926336d44fd7b26a92c3e2b7735a8d4b2e50e"
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
