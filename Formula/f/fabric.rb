class Fabric < Formula
  include Language::Python::Virtualenv

  desc "Library and command-line tool for SSH"
  homepage "https://www.fabfile.org/"
  url "https://files.pythonhosted.org/packages/e3/7e/29cd6237c3b7ce79c3ca945eb99ab5affd101db54b2f7a78dde0cfa19fd4/fabric-3.2.3.tar.gz"
  sha256 "dcbd2c47ad87688facaef5cc11aab6d1ec9ed05645fed97a5de7204d5d17cc44"
  license "BSD-2-Clause"
  head "https://github.com/fabric/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e9cb8e0cc7a75a650f3dd0ecf8334be67063e6bcca58bf01308f8b63355e554d"
    sha256 cellar: :any,                 arm64_sequoia: "6e75e16112471fffe1f25bba97eb332fd3da512506658659e5738e40d97878b7"
    sha256 cellar: :any,                 arm64_sonoma:  "5600994391198714d5213af0cfc57199958b74d1d60f4caec479c31ef29342af"
    sha256 cellar: :any,                 sonoma:        "2203604eec4f3c27cb42b581943b021a3509b9ac6412f73fbbf6e6df145f3e86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6997f1ce970478c673e28a3ab50f489ee6143861b6ddb68c3741cdc8ed45b84f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdb1381b5b253e567f4dbba55be51ef0d83f14c85ce437f085ad558524fdc421"
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
    url "https://files.pythonhosted.org/packages/1f/e7/81fdcbc7f190cdb058cffc9431587eb289833bdd633e2002455ca9bb13d4/paramiko-4.0.0.tar.gz"
    sha256 "6a25f07b380cc9c9a88d2b920ad37167ac4667f8d9886ccebd8f90f654b5d69f"
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
