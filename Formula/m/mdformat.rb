class Mdformat < Formula
  include Language::Python::Virtualenv

  desc "CommonMark compliant Markdown formatter"
  homepage "https://mdformat.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/3f/05/32b5e14b192b0a8a309f32232c580aefedd9d06017cb8fe8fce34bec654c/mdformat-1.0.0.tar.gz"
  sha256 "4954045fcae797c29f86d4ad879e43bb151fa55dbaf74ac6eaeacf1d45bb3928"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "863671318644528a8d19c96fd1bad11e378951569eebf8db95004d872c108a30"
  end

  depends_on "python@3.14"

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdformat-frontmatter" do
    url "https://files.pythonhosted.org/packages/c0/94/ccb15e0535f35c21b2b533cafb232f11ac0e7046dd122029b7ec0513c82e/mdformat_frontmatter-2.0.10.tar.gz"
    sha256 "decefcb4beb66cf111f17e8c0d82e60b208104c7922ec09564d05365db551bd8"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/b2/fd/a756d36c0bfba5f6e39a1cdbdbfdd448dc02692467d83816dff4592a1ebc/mdit_py_plugins-0.5.0.tar.gz"
    sha256 "f4918cb50119f50446560513a8e311d574ff6aaed72606ddae6d35716fe809c6"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/c7/3b/ebda527b56beb90cb7652cb1c7e4f91f48649fbcd8d2eb2fb6e77cd3329b/ruamel_yaml-0.19.1.tar.gz"
    sha256 "53eb66cd27849eff968ebf8f0bf61f46cdac2da1d1f3576dd4ccee9b25c31993"
  end

  def install
    virtualenv_install_with_resources

    # Patch mdformat-frontmatter to preserve YAML string quotes.
    # Without this, ruamel.yaml strips "unnecessary" quotes on round-trip,
    # producing unwanted diffs in frontmatter.
    # Upstream fix: https://github.com/butler54/mdformat-frontmatter/issues/42
    site_packages = libexec/Language::Python.site_packages("python3")
    inreplace site_packages/"mdformat_frontmatter/plugin.py",
      "yaml = ruamel.yaml.YAML()",
      "yaml = ruamel.yaml.YAML()\nyaml.preserve_quotes = True"
  end

  test do
    (testpath/"test.md").write("# mdformat")
    system bin/"mdformat", testpath

    # Frontmatter preservation test
    (testpath/"frontmatter.md").write("---\ntitle: Test\n---\n\n# Hello\n")
    system bin/"mdformat", testpath/"frontmatter.md"
    output = (testpath/"frontmatter.md").read
    assert_match "---\ntitle: Test\n---", output

    # Quote preservation test
    (testpath/"quotes.md").write("---\ntitle: \"Quoted\"\n---\n\n# Hello\n")
    system bin/"mdformat", testpath/"quotes.md"
    output = (testpath/"quotes.md").read
    assert_match '"Quoted"', output
  end
end
