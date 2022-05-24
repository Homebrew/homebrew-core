class Meson < Formula
  include Language::Python::Virtualenv

  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.62.1/meson-0.62.1.tar.gz"
  sha256 "a0f5caa1e70da12d5e63aa6a9504273759b891af36c8d87de381a4ed1380e845"
  license "Apache-2.0"
  head "https://github.com/mesonbuild/meson.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74ec8b05193ad6f0a192ea976a898362d322d8a51056a0563baf60f844403ed8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f61040da2d88d7e57b8ec042d0f61fd88d1d296582d52203c5558acfc62d7b4b"
    sha256 cellar: :any_skip_relocation, monterey:       "7b26a7c72350fc2d72957a0b1b26393d6ce99f2f77d8f97eebc7b0bc174a227c"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd5c2f2ca156a974b1c85960091ece4a477211a79db360a925f86a9bfc4dd97c"
    sha256 cellar: :any_skip_relocation, catalina:       "ce1d410239c715e3f42dd2dfcc193bd7db7a3cd50231029b6d76f73fe7b6bd9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3caf61e3ad496e94e4ce6292a01241bd7dd7ae2571bae949760e574b8fa80b1c"
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
