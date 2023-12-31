class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://pipx.pypa.io"
  url "https://files.pythonhosted.org/packages/0e/78/85a816ce8ddc4f456ada533ee4218ef657b152862f411b9f4658629e4a17/pipx-1.4.0.tar.gz"
  sha256 "dbdf88e25ae8964e76ce4efe013a1e50893f22df92fcb0934aadb91653af2074"
  license "MIT"
  head "https://github.com/pypa/pipx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2674732e6fcc7639acfc2af967489fe85741b2cddbf469c7cc6b363d1b0227f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec5ad8ccb908dfd0c360a2431bfdef897b52bd8f75c03c3663f3b0f33de2298f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f11b86b2f9fea40e1272af98ceccd5ed589bc78bb04004273c5be4c6d4b6b6be"
    sha256 cellar: :any_skip_relocation, sonoma:         "436c47f93ea9a83840d18ccc728abaa4aa3ec4ec6ccd734b260687cc05b13782"
    sha256 cellar: :any_skip_relocation, ventura:        "5587c5557da31abc2861cb921087b4daf7c8fcc846cfbc7728ffda624d8f0ad8"
    sha256 cellar: :any_skip_relocation, monterey:       "2979d5c3887217239614ba2a88bc740a6270903548eaabcd6b0f5efef526a4bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98a0cf2122fb0b7947cb87d7f957ba41af3e1dc9147106b00acb80bdc63de152"
  end

  depends_on "python-argcomplete"
  depends_on "python-packaging"
  depends_on "python@3.12"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/62/d1/7feaaacb1a3faeba96c06e6c5091f90695cc0f94b7e8e1a3a3fe2b33ff9a/platformdirs-4.1.0.tar.gz"
    sha256 "906d548203468492d432bcb294d4bc2fff751bf84971fbb2c10918cc206ee420"
  end

  resource "userpath" do
    url "https://files.pythonhosted.org/packages/4d/13/b8c47191994abd86cbdb256146dbd7bbabcaaa991984b720f68ccc857bfc/userpath-1.9.1.tar.gz"
    sha256 "ce8176728d98c914b6401781bf3b23fccd968d1647539c8788c7010375e02796"
  end

  def python3
    deps.map(&:to_formula)
        .find { |f| f.name.start_with?("python@") }
  end

  def install
    # Avoid Cellar path reference, which is only good for one version.
    inreplace "src/pipx/interpreter.py",
              "DEFAULT_PYTHON = _get_sys_executable()",
              "DEFAULT_PYTHON = '#{python3.opt_libexec/"bin/python"}'"

    virtualenv_install_with_resources

    register_argcomplete = Formula["python-argcomplete"].opt_bin/"register-python-argcomplete"
    generate_completions_from_executable(register_argcomplete, "pipx", shell_parameter_format: :arg)
  end

  test do
    assert_match "PIPX_HOME", shell_output("#{bin}/pipx --help")
    system bin/"pipx", "install", "csvkit"
    assert_predicate testpath/".local/bin/csvjoin", :exist?
    system bin/"pipx", "uninstall", "csvkit"
    refute_match "csvjoin", shell_output("#{bin}/pipx list")
  end
end
