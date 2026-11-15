class Libuv < Formula
  include Language::Python::Virtualenv

  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://libuv.org/"
  url "https://dist.libuv.org/dist/v1.53.0/libuv-v1.53.0.tar.gz"
  sha256 "cb0d6dd2128d5a95bd242c6cc982a24fe608fa93da57b6b4ec763b0018c53e64"
  license "MIT"
  compatibility_version 1
  head "https://github.com/libuv/libuv.git", branch: "v1.x"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2fea505cd00bcf4b00c6f39a8a70a7b669b57db9c7ced4195c59221f4647c9b6"
    sha256 cellar: :any, arm64_tahoe:       "76e5d3743160ff4da9a91f35f1e10614ffef9c4aeafb8f44e8e7b07a9bfa32fe"
    sha256 cellar: :any, arm64_sequoia:     "fd36aed546040f791778940d56586bbbeaa2f8ed804f1a957b4baf83657d5b1f"
    sha256 cellar: :any, arm64_linux:       "d0980c41c5fd765f0e2936fccc4ab0e29c147ca464601fca52d2a75621817235"
    sha256 cellar: :any, x86_64_linux:      "5697a3e2ebf129603045c088824fb7fcf5e99fcf139eeed6239bc50375ad4cae"
  end

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build # for sphinx-copybutton
  depends_on "sphinx-doc" => :build

  pypi_packages package_name:     "",
                exclude_packages: "sphinx",
                extra_packages:   "sphinx-copybutton"

  resource "sphinx-copybutton" do
    url "https://files.pythonhosted.org/packages/fc/2b/a964715e7f5295f77509e59309959f4125122d648f86b4fe7d70ca1d882c/sphinx-copybutton-0.5.2.tar.gz"
    sha256 "4cf17c82fb9646d1bc9ca92ac280813a3b605d8c421225fd9913154103ee1fbd"
  end

  deny_network_access!

  def install
    venv = virtualenv_create(buildpath/"venv", Formula["sphinx-doc"].python3)
    venv.pip_install resources, build_isolation: false
    ENV.prepend_path "PYTHONPATH", venv.site_packages

    # This isn't yet handled by the make install process sadly.
    system "make", "-C", "docs", "man"
    man1.install "docs/build/man/libuv.1"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <uv.h>
      #include <stdlib.h>

      int main()
      {
        uv_loop_t* loop = malloc(sizeof *loop);
        uv_loop_init(loop);
        uv_loop_close(loop);
        free(loop);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-luv", "-o", "test"
    system "./test"
  end
end
