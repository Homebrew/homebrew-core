class Meson < Formula
  include Language::Python::Virtualenv

  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.62.0/meson-0.62.0.tar.gz"
  sha256 "06f8c1cfa51bfdb533c82623ffa524cacdbea02ace6d709145e33aabdad6adcb"
  license "Apache-2.0"
  head "https://github.com/mesonbuild/meson.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "574cbd1941554288673cae34643fe51ec130f7a26ca19deec7d4f47707930a8b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "053f189c8e19e0a2e6d63479b0450237060b4b88bcec51a5d46b627ca1b74ea8"
    sha256 cellar: :any_skip_relocation, monterey:       "d3d333492b00d8539418ff29776bed4e0259bd2b102ed805282e5997a0e0281e"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cdc50a7fee26aeb7d2b9e134ccf7af08e55001cc91925339765e9cf1baea8eb"
    sha256 cellar: :any_skip_relocation, catalina:       "4a5fde510e6384e12039ca1e1ba0d766de1bd140d0a03aabc0b19a115210759b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46f6c33901fb68783eab08a21037f20b6923fc41cae21c416d8e9fb8e4eec439"
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
