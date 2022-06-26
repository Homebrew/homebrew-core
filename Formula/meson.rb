class Meson < Formula
  include Language::Python::Virtualenv

  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.62.2/meson-0.62.2.tar.gz"
  sha256 "a7669e4c4110b06b743d57cc5d6432591a6677ef2402139fe4f3d42ac13380b0"
  license "Apache-2.0"
  head "https://github.com/mesonbuild/meson.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73407d2f1c6fcf9f13f2ceef994fc0617f89991f6f1e3f1fe6f4dcd7c8aeedef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f16ddc798ba5a4aa4b508efde8e2cfdc2e14fc62365f26aa909587b1d5ecd715"
    sha256 cellar: :any_skip_relocation, monterey:       "f5b336640a42a47fa4a51600050fa2559fca02315a23e9fded568c62f8862a9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6bc003489ada56eb600f6d0b8de7b88648b0b7d9cc8e0a6aa69e059e20a068b"
    sha256 cellar: :any_skip_relocation, catalina:       "fecf98433603a2d298929874ef6b2494957bfa668c6c14a587d14656abcaa65d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7aaaa9a8be102654d79f353caed982cf13fa05c250da27f254ee2a4b0d3759c7"
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
