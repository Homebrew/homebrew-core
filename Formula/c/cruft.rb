class Cruft < Formula
  include Language::Python::Virtualenv

  desc "Utility that creates projects from templates and maintains the cruft afterwards"
  homepage "https://cruft.github.io/cruft/"
  url "https://files.pythonhosted.org/packages/d8/59/bb9e052fba37972e4b27db74d0bc770bade501d48336dec3c89fe57e9513/cruft-2.15.0.tar.gz"
  sha256 "9802af66037418655e7e4b6f30b531591e0761939b3ff5dd45d27c3a3f588abe"
  license "MIT"
  revision 6
  head "https://github.com/cruft/cruft.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6de6d61219b899715a02e70aab063caf285a83cf137b5601e7d672846d45d32f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfadbc63d63af965507d9e54745ee62e0c9efa7575d2ddf9cf00000cd1358561"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84dfec6a1e4cf0c64cd352c39a9169b956320a557fe86b53bbccebca8be46d59"
    sha256 cellar: :any_skip_relocation, sonoma:         "970c605f36d6def9d0c59e4385d3c676cf311ee5840060b8fd5f0d2f23a28128"
    sha256 cellar: :any_skip_relocation, ventura:        "925ccc230ae298d456736fa56efb07c09185d4228937f03e0aaf8ce612208f5f"
    sha256 cellar: :any_skip_relocation, monterey:       "7528b0fff86e4edb1dd08f522d909f484ec13a109a78b41c4c1688ca82702086"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a225a4bbf79bbcf5aaeb1be364b526e73cdf203cc38349f43455f63a24caf93"
  end

  depends_on "cookiecutter"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "six"

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/19/0d/bbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8ed/gitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/e5/c2/6e3a26945a7ff7cf2854b8825026cf3f22ac8e18285bc11b6b1ceeb8dc3f/GitPython-3.1.41.tar.gz"
    sha256 "ed66e624884f76df22c8e16066d567aaa5a37d5b5fa19db2c6df6f7156db9048"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/88/04/b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baa/smmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/5b/49/39f10d0f75886439ab3dac889f14f8ad511982a754e382c9b6ca895b29e9/typer-0.9.0.tar.gz"
    sha256 "50922fd79aea2f4751a8e0408ff10d2662bd0c8bbfa84755a699f3bada2978b2"
  end

  def python3
    which("python3.12")
  end

  def install
    virtualenv_install_with_resources

    # we depend on cookiecutter, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages(python3)
    cookiecutter = Formula["cookiecutter"].opt_libexec
    (libexec/site_packages/"homebrew-cookiecutter.pth").write cookiecutter/site_packages
  end

  test do
    system bin/"cruft", "create", "--no-input", "https://github.com/audreyr/cookiecutter-pypackage.git"
    assert (testpath/"python_boilerplate").directory?
    assert_predicate testpath/"python_boilerplate/.cruft.json", :exist?
  end
end
