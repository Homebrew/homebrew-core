class Peru < Formula
  include Language::Python::Virtualenv

  desc "Dependency retriever for version control and archives"
  homepage "https://github.com/buildinspace/peru"
  url "https://files.pythonhosted.org/packages/8e/c7/c451e70443c0b82440384d51f4b9517b921d4fe44172d63dc10a09da114f/peru-1.3.1.tar.gz"
  sha256 "31cbcc3b1c0663866fcfb2065cb7ac26fda1843a3e5638f260cc0d78b3372f39"
  license "MIT"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4fe6741a51002284c7cf18864a7d7e75f55dd82ba085102fe5785f392a60b7db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecf79403dba06b8ed9b82d9a2a4f307b91d7cf08773b606921ea9dea006e017e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "219316df676d2b308854a5fb074836cab3d9cdc9c520b3354c29de3218cb19a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "a73f064a78a1e8c353e798f7c3471f156d59d3a04f66f184460b53a8de6f5e22"
    sha256 cellar: :any_skip_relocation, ventura:        "8b850b6763e6b83854e06bdc81ed512f3b3cb7f45c8178b9c1ec241306697744"
    sha256 cellar: :any_skip_relocation, monterey:       "f473af78b2dbca0073c4ab4be030b2ff57f1cb505fc4ba8368a5df1609b74690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "761eccab8b61910522dd259608851e2dcd533f92e5c02272e21f760e1f3ddd4c"
  end

  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  def install
    # Fix plugins (executed like an executable) looking for Python outside the virtualenv
    Dir["peru/resources/plugins/**/*.py"].each do |f|
      inreplace f, "#! /usr/bin/env python3", "#!#{libexec}/bin/python3.12"
    end

    virtualenv_install_with_resources
  end

  test do
    (testpath/"peru.yaml").write <<~EOS
      imports:
        peru: peru
      git module peru:
        url: https://github.com/buildinspace/peru.git
    EOS
    system "#{bin}/peru", "sync"
    assert_predicate testpath/".peru", :exist?
    assert_predicate testpath/"peru", :exist?
  end
end
