class Peru < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Dependency retriever for version control and archives"
  homepage "https://github.com/buildinspace/peru"
  url "https://files.pythonhosted.org/packages/46/93/97b31e2052b4308cbc413d85b6b6b08a3beeeac81996b070723418a0c24e/peru-1.3.5.tar.gz"
  sha256 "2cc1a0d09c5d4fc28dda5c4bf87b4110ee2107e9ce7fb6a38f8d6f60a91af745"
  license "MIT"
  head "https://github.com/buildinspace/peru.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "b58c5fd45085887e66448ce84898bfd92416acf768c6e450095ab3d4fd9611ab"
    sha256 cellar: :any, arm64_tahoe:       "1225528b3151402c59e607982d0686643d77ae510b05ede6a829776cb05ab638"
    sha256 cellar: :any, arm64_sequoia:     "3024f57fa07ba7b6251605bc99af6af490dd9463ba135e76b3b4a17993e2bd3a"
    sha256 cellar: :any, arm64_linux:       "a48224577d15e40447662a6ea737292a36fad06bb13fbab73e7e6b009e2b2e01"
    sha256 cellar: :any, x86_64_linux:      "c62725aec4d75736ab194f803f43c02eea5929cd75fed48216dff61030153405"
  end

  depends_on "libyaml"
  depends_on "python@3.15"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    venv = virtualenv_install_with_resources

    # Fix executable plugins looking for Python outside the virtualenv
    rw_info = python_shebang_rewrite_info(venv.root/"bin/python")
    rewrite_shebang rw_info, *venv.site_packages.glob("peru/resources/plugins/**/*.py")
  end

  test do
    (testpath/"peru.yaml").write <<~YAML
      imports:
        peru: peru
      git module peru:
        url: https://github.com/buildinspace/peru.git
    YAML

    system bin/"peru", "sync"
    assert_path_exists testpath/".peru"
    assert_path_exists testpath/"peru"
  end
end
