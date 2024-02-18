class Mkdocs < Formula
  include Language::Python::Virtualenv

  desc "Project documentation with Markdown"
  homepage "https://www.mkdocs.org/"
  url "https://files.pythonhosted.org/packages/ed/bb/24a22f8154cf79b07b45da070633613837d6e59c7d870076f693b7b1c556/mkdocs-1.5.3.tar.gz"
  sha256 "eb7c99214dcb945313ba30426c2451b735992c73c2e10838f76d09e39ff4d0e2"
  license "BSD-2-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d0b20c91da8acd2d3f1749a7dc8489ab06dd0456068831ecda5d580c1a897e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59f23c7bcd08eac3aedb8547929ffbde6afa528f02f38446b6e158046e41a4b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4d0ad0a28961000a41d2dfc37011fdfe56daf96ac218e4a33653852acfc189b"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b1b5501b96d3fdcc00c453d46a0250252cbe840d1ec236e98f67818ba59dfbc"
    sha256 cellar: :any_skip_relocation, ventura:        "15a6055ed615e0ee269d9cbe0110bcf7c3ac533c4398f07232301ffcafa8c6fe"
    sha256 cellar: :any_skip_relocation, monterey:       "4835bbf4f22dcd32966a8e9ba815af628520ffda127114ea57d62cdb5b393ad8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b29c71711f0013edc43925538e8aad3cc7e9f3f34db6e31da3a21f65da7481e5"
  end

  depends_on "python@3.12"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "ghp-import" do
    url "https://files.pythonhosted.org/packages/d9/29/d40217cbe2f6b1359e00c6c307bb3fc876ba74068cbab3dde77f03ca0dc4/ghp-import-2.1.0.tar.gz"
    sha256 "9c535c4c61193c2df8871222567d7fd7e5014d835f97dc7b7439069e2413d343"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/b2/5e/3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1/Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/11/28/c5441a6642681d92de56063fa7984df56f783d3f1eba518dc3e7a253b606/Markdown-3.5.2.tar.gz"
    sha256 "e1ac7b3dc550ee80e602e71c1d168002f062e49f1b11e26a36264dafd4df2ef8"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "mergedeep" do
    url "https://files.pythonhosted.org/packages/3a/41/580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270/mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/96/dc/c1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8/platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "pyyaml-env-tag" do
    url "https://files.pythonhosted.org/packages/fb/8e/da1c6c58f751b70f8ceb1eb25bc25d524e8f14fe16edcce3f4e3ba08629c/pyyaml_env_tag-0.1.tar.gz"
    sha256 "70092675bda14fdec33b31ba77e7543de9ddc88f2e5b99160396572d11525bdb"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/cd/3c/43eeaa9ea17a2657d639aa3827beaa77042809410f86fb76f0d0ea6a2102/watchdog-4.0.0.tar.gz"
    sha256 "e3e7065cbdabe6183ab82199d7a4f6b3ba0a438c5a512a68559846ccb76a78ec"
  end

  # Add missing setuptools dep
  patch do
    url "https://github.com/mkdocs/mkdocs/commit/cc76672d5591b444e425423e41a0f5c0d42de9f8.patch?full_index=1"
    sha256 "7fdd3f760c25b9d08a4e97448fdb629a418913adc2d6222b2752719fe0ace60c"
  end

  def install
    ENV["PIP_USE_PEP517"] = "1"
    virtualenv_install_with_resources
  end

  test do
    # build a very simple site that uses the "readthedocs" theme.
    (testpath/"mkdocs.yml").write <<~EOS
      site_name: MkLorum
      nav:
        - Home: index.md
      theme: readthedocs
    EOS
    mkdir testpath/"docs"
    (testpath/"docs/index.md").write <<~EOS
      # A heading

      And some deeply meaningful prose.
    EOS
    system "#{bin}/mkdocs", "build", "--clean"
  end
end
