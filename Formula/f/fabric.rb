class Fabric < Formula
  include Language::Python::Virtualenv

  desc "Library and command-line tool for SSH"
  homepage "https://www.fabfile.org/"
  url "https://files.pythonhosted.org/packages/e3/7e/29cd6237c3b7ce79c3ca945eb99ab5affd101db54b2f7a78dde0cfa19fd4/fabric-3.2.3.tar.gz"
  sha256 "dcbd2c47ad87688facaef5cc11aab6d1ec9ed05645fed97a5de7204d5d17cc44"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/fabric/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1177e8a10b8224740416642316730300b708f7a2266100d41a89f7127995c327"
    sha256 cellar: :any,                 arm64_sequoia: "b4be3fd62c518105bfbcfd7f1880f5e1bf1c4483a0208e746300ce07ca866172"
    sha256 cellar: :any,                 arm64_sonoma:  "869c3c99def5951d5347ae9397aaf290c7cbacde40d6e92a12439122cd0eed16"
    sha256 cellar: :any,                 sonoma:        "dfdd62823570836bfbedb2f5a86cf4fb4ae9fab23aefab8f0246d71781b220a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "125d533ad61f91b06c6e58b94dfc75be4809e523df694f8be9321a552c389212"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e2c3b200325ff671ff12bc50d12c6698e7f13bb449e6faf90b8a284da2e840f"
  end

  # `pkgconf` and `rust` are for bcrypt
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "cryptography"
  depends_on "libsodium" # for pynacl
  depends_on "python@3.14"

  pypi_packages exclude_packages: "cryptography",
                extra_packages:   "decorator"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d4/36/3329e2518d70ad8e2e5817d5a4cac6bba05a47767ec416c7d020a965f408/bcrypt-5.0.0.tar.gz"
    sha256 "f748f7c2d6fd375cc93d3fba7ef4a9e3a092421b8dbf34d8d4dc06be9492dfdd"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/43/fa/6d96a0978d19e17b68d634497769987b16c8f4cd0a7a05048bec693caa6b/decorator-5.2.1.tar.gz"
    sha256 "65f266143752f734b0a7cc83c46f4618af75b8c5911b00ccb61d0ac9b6da0360"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/49/85/12f0a49a7c4ffb70572b6c2ef13c90c88fd190debda93b23f026b25f9634/deprecated-1.3.1.tar.gz"
    sha256 "b1b50e0ff0c1fddaa5708a2c6b0a6588bb09b892825ab2b214ac9ea9d92a5223"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/de/bd/b461d3424a24c80490313fd77feeb666ca4f6a28c7e72713e3d9095719b4/invoke-2.2.1.tar.gz"
    sha256 "515bf49b4a48932b79b024590348da22f39c4942dff991ad1fb8b8baea1be707"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/62/93/dcc25d52f49022ae6175d15e6bd751f1acc99b98bc61fc55e5155a7be2e7/paramiko-5.0.0.tar.gz"
    sha256 "36763b5b95c2a0dcfdf1abc48e48156ee425b21efe2f0e787c2dd5a95c0e5e79"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/d9/9a/4019b524b03a13438637b11538c82781a5eda427394380381af8f04f467a/pynacl-1.6.2.tar.gz"
    sha256 "018494d6d696ae03c7e656e5e74cdfd8ea1326962cc401bcf018f1ed8436811c"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/2e/64/925f213fdcbb9baeb1530449ac71a4d57fc361c053d06bf78d0c5c7cd80c/wrapt-2.1.2.tar.gz"
    sha256 "3996a67eecc2c68fd47b4e3c564405a5777367adfd9b8abb58387b63ee83b21e"
  end

  def install
    ENV["SODIUM_INSTALL"] = "system"
    virtualenv_install_with_resources
  end

  test do
    (testpath/"fabfile.py").write <<~PYTHON
      from invoke import task
      import fabric
      @task
      def hello(c):
        c.run("echo {}".format(fabric.__version__))
    PYTHON
    assert_equal version.to_s, shell_output("#{bin}/fab hello").chomp
  end
end
