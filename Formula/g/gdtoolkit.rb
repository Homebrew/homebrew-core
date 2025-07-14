class Gdtoolkit < Formula
  include Language::Python::Virtualenv

  desc "Independent set of GDScript tools - parser, linter, formatter, and more"
  homepage "https://github.com/Scony/godot-gdscript-toolkit"
  url "https://files.pythonhosted.org/packages/8f/8c/ec8eb8e8264fedcfc1f30374b56083b917dd187a9e2452d38cabac69f515/gdtoolkit-4.3.4.tar.gz"
  sha256 "42f8d528829a081809c8492c5936729b9fafca640fc46026ae98299fe0d3a93a"
  license "MIT"
  head "https://github.com/Scony/godot-gdscript-toolkit.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a19edd8a6ab82c0588208bba5c2549e2e309d67e5260037d37392b56c4c6a274"
    sha256 cellar: :any,                 arm64_sonoma:  "487736b81a2755903965533b6f4d0eca6b212d38e5dd4af6dff31dc8c01ac0dd"
    sha256 cellar: :any,                 arm64_ventura: "e6d5dbf25ac8cf47e8ee33d20fdb72b2ca451aec83150c907a30ffc22f091d3d"
    sha256 cellar: :any,                 sonoma:        "2d930f9595453844e4778c67d2463a56a9882f22282f53671948564df9d0efb3"
    sha256 cellar: :any,                 ventura:       "8b07ef1a7ad6c6ae11a78f27cf0b8ec0ad07ac51769ca1eb13a7d1174bd26916"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "233733e1fdf3b5cb9bac8d4df7e0dda858bbea5856e7e009de1edbc467bb27ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f67079ec7ddd415b8036408e90c4215d2bc6a763040c367ce9c83647a26d6c6c"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

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
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "radon" do
    url "https://files.pythonhosted.org/packages/b1/6d/98e61600febf6bd929cf04154537c39dc577ce414bafbfc24a286c4fa76d/radon-6.0.1.tar.gz"
    sha256 "d1ac0053943a893878940fedc8b19ace70386fc9c9bf0a09229a44125ebf45b5"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/8e/5f/bd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cb/regex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
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
