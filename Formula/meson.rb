class Meson < Formula
  include Language::Python::Virtualenv

  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.61.3/meson-0.61.3.tar.gz"
  sha256 "9c884434469471f3fe0cbbceb9b9ea0c8047f19e792940e1df6595741aae251b"
  license "Apache-2.0"
  head "https://github.com/mesonbuild/meson.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e869d1bccc483c8048c4d34b0ec7f6cf60e60094135569763fd2fd6cf6d3bc9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b33231e644e839ee9872594b7311e4833ffd0c390c4f30117233224177c4558"
    sha256 cellar: :any_skip_relocation, monterey:       "a9d8f942d207b4801f80470b432dd1ab8af169824623374ddb81e6ff68e54290"
    sha256 cellar: :any_skip_relocation, big_sur:        "18f6084128226bae2452c5cdf58b2a41be20c3af31eba0261712fef4630a0c5d"
    sha256 cellar: :any_skip_relocation, catalina:       "29ec98d0196028cc9a70dda833554085b7bdd1ef0a4c100d7b59b60ec4362f9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c919806f5f6bd77f01ba8b6acfa875e71ee254f476c8f3d023c52d5f770b3ee1"
  end

  depends_on "ninja"
  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
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
