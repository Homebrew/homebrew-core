class Meson < Formula
  include Language::Python::Virtualenv

  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.61.3/meson-0.61.3.tar.gz"
  sha256 "9c884434469471f3fe0cbbceb9b9ea0c8047f19e792940e1df6595741aae251b"
  license "Apache-2.0"
  head "https://github.com/mesonbuild/meson.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aee80bab5dfe834fb055caa14d4be68618ddb4e64c67ec72bb6f7cf9e795d770"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9250e26f115ffb02500d43fc4bded70c856c37d088820775c25e3271a0dc13b"
    sha256 cellar: :any_skip_relocation, monterey:       "4f620c91502427dcf6bfc3d2f14d3eb9a1ddf98cb3beb7db54c0b73f4b1eabf3"
    sha256 cellar: :any_skip_relocation, big_sur:        "f42c1aa6764bb04616f574dd1a1c22c4105c61e7f5b109177f6e5c581f687139"
    sha256 cellar: :any_skip_relocation, catalina:       "66e5aee5a7f15af8025db6939189450fc8a3efbdf4f6ca9b8f158bec587e497f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dfc61a3fbfee202ac695ff0df2f045de9b6cf88423029807be4da0e772ad000"
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
