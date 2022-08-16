class Meson < Formula
  include Language::Python::Virtualenv

  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.63.1/meson-0.63.1.tar.gz"
  sha256 "06fe13297213d6ff0121c5d5aab25a56ef938ffec57414ed6086fda272cb65e9"
  license "Apache-2.0"
  head "https://github.com/mesonbuild/meson.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1edf538c453cbec408f2e27a77fb1ff5b7f27c14fcacc1df89a4fe35a81c18fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc47dabc0951303ba48d3a708fcbeaf9ce6ef2c97273e454d12ffe67e9f72811"
    sha256 cellar: :any_skip_relocation, monterey:       "660113e702d14019736eb1a51f07c50b7fd2e40fb99b1ca5e3d252c511e1c649"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c60a0c0b241cb793a4ce18d9f1ce033b28f4ae4611ed7f0166d67f8d30b6506"
    sha256 cellar: :any_skip_relocation, catalina:       "ee356711d4b77598ed0954ea4a52772587438921dedfc68ac66212d3fbe8c132"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97e0884c96bfb0b537eabd636dcb9fb4dcbf4edd831c9293aa1524aad042f593"
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
