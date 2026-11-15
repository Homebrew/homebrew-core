class Gdtoolkit < Formula
  include Language::Python::Virtualenv

  desc "Independent set of GDScript tools - parser, linter, formatter, and more"
  homepage "https://github.com/Scony/godot-gdscript-toolkit"
  url "https://files.pythonhosted.org/packages/de/39/041c1705dba6450c67e23be0c70d0fcff035e7d240b6695fc59efd8dafb6/gdtoolkit-4.5.0.tar.gz"
  sha256 "1ab17fb5400d86e4ae66d9c94992f4e3a9b6c27d618d4094782e66101efb3e9a"
  license "MIT"
  revision 2
  head "https://github.com/Scony/godot-gdscript-toolkit.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3a3701c39c9ed659965415b1de6cb5f6af0b0ef74e3f13123500ad93a782c163"
    sha256 cellar: :any, arm64_tahoe:       "58bfb8a793290379afe32a957bf0cd0b22a799ca367a173c1bfec6d56994f609"
    sha256 cellar: :any, arm64_sequoia:     "f5c6caaa69d03d6a2aff6d574dc27f23ae490fe7d07f986eae697e5a1ee61831"
    sha256 cellar: :any, arm64_linux:       "f9493236e127af0ef8e6da5d2ca73122325841bb4b3651695744472685677ecd"
    sha256 cellar: :any, x86_64_linux:      "29d649c5ad1c0ff236929cfd785ff9ea7f3f1ca32ba54156853c13eda0dbe39c"
  end

  depends_on "libyaml"
  depends_on "python@3.15"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "docopt-ng" do
    url "https://files.pythonhosted.org/packages/e4/50/8d6806cf13138127692ae6ff79ddeb4e25eb3b0bcc3c1bd033e7e04531a9/docopt_ng-0.9.0.tar.gz"
    sha256 "91c6da10b5bb6f2e9e25345829fb8278c78af019f6fc40887ad49b060483b1d7"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/af/60/bc7622aefb2aee1c0b4ba23c1446d3e30225c8770b38d7aedbfb65ca9d5a/lark-1.2.2.tar.gz"
    sha256 "ca807d0162cd16cef15a8feecb862d7319e7a09bdb13aef927968e45040fed80"
  end

  resource "mando" do
    url "https://files.pythonhosted.org/packages/35/24/cd70d5ae6d35962be752feccb7dca80b5e0c2d450e995b16abd6275f3296/mando-0.7.1.tar.gz"
    sha256 "18baa999b4b613faefb00eac4efadcf14f510b59b924b66e08289aa1de8c3500"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "radon" do
    url "https://files.pythonhosted.org/packages/b1/6d/98e61600febf6bd929cf04154537c39dc577ce414bafbfc24a286c4fa76d/radon-6.0.1.tar.gz"
    sha256 "d1ac0053943a893878940fedc8b19ace70386fc9c9bf0a09229a44125ebf45b5"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/fc/f2/af1da9d3ceed77bfcdce40427d49ba0be94e4fe84245e3bfef68c10e75b6/regex-2026.9.29.tar.gz"
    sha256 "8b5fcc4771732191b2b7d1dd68d8f0353f47f8d90b6150f6dce58bf1112442cb"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/70/b3/c19426f783614d625699a4b247faf628ea9ab1db228674491767b417f9e1/setuptools-84.2.1.tar.gz"
    sha256 "3ff8b3b5492a0aa66960f4419365a86b84e013070d4313e4d4a6894f5d64d6bc"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # gdformat
    (testpath/"gdformat.gd").write "func foo(): pass"
    format_expected = <<~DIFF
      would reformat #{testpath}/gdformat.gd
      --- #{testpath}/gdformat.gd
      +++ #{testpath}/gdformat.gd
      @@ -1 +1,2 @@
      -func foo(): pass
      +func foo():
      +\tpass
      1 file would be reformatted, 0 files would be left unchanged.
    DIFF
    assert_equal format_expected, shell_output("#{bin}/gdformat --diff #{testpath}/gdformat.gd 2>&1", 1)

    # gdlint
    (testpath/"gdlint.gd").write "func notValid(): pass"
    lint_expected = <<~EOS
      #{testpath}/gdlint.gd:1: Error: Function name "notValid" is not valid (function-name)
      Failure: 1 problem found
    EOS
    assert_equal lint_expected, shell_output("#{bin}/gdlint #{testpath}/gdlint.gd 2>&1", 1)

    # gdparse
    parse_expexted = <<~EOS
      gdformat.gd:

      start
        func_def
          func_header
            foo
            func_args
          pass_stmt

    EOS
    assert_equal parse_expexted, shell_output("#{bin}/gdparse gdformat.gd -p")

    # gdradon
    (testpath/"gdradon.gd").write <<~EOS
      func foo():
        pass
        var a
        var b = 1
        var c: int
        var d: int = 1
        var e := 1
        """xxx"""
        if 1:
          pass
        elif 1:
          pass
        else:
          pass
        while 1:
          break
        for i in 1:
          continue
        for j: int in 1:
          continue
        match 1:
          1:
            pass
          1:
            pass
        return
        return 1
    EOS
    radon_expexted = <<~EOS
      gdradon.gd
          F 1:0 foo - B (9)
    EOS
    assert_equal radon_expexted, shell_output("#{bin}/gdradon cc gdradon.gd")
  end
end
