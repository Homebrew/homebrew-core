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
    sha256 cellar: :any,                 arm64_tahoe:   "5a7e7669fb8cdf7e4bf5175f9d01be1d0a9d75aa693c6161c2b27145a8c62059"
    sha256 cellar: :any,                 arm64_sequoia: "1b2840d24355227568032ad13df06a4ab9d0ae8c61bf2477d0f837fe7bb7b4a2"
    sha256 cellar: :any,                 arm64_sonoma:  "d4b0ba0f201b97d60292fd8f2539cdfa0e71b24ccccc963f40dbcd5ab03e8565"
    sha256 cellar: :any,                 sonoma:        "1d7ba45fd3db6b8154eee9d11ddc65859dc8be21ed882e9907c856d2d496c975"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d90e59b8f68ff875b46e7edea66ca293733abcdc5b071153ce347d3ca3ee484e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65b950ac4d3bb7af7bdd3221cad598590f02663010bb27d6176501dea43bd61c"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

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
