class Flit < Formula
  include Language::Python::Virtualenv

  desc "Simplified packaging of Python modules"
  homepage "https://github.com/takluyver/flit"
  url "https://files.pythonhosted.org/packages/60/53/6b28b1f2d11ea1ea1974eccd46a298d8120f768fd5cb7e7bc52b3718db86/flit-3.0.0.tar.gz"
  sha256 "b4fe0f84a1ffbf125d003e253ec98c0b6e3e31290b31fba3ad22d28588c20893"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/takluyver/flit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eaacd91b91e1089335658abacee98049ca9a989fd5e7675120cd8afdfdc7a58e" => :big_sur
    sha256 "a7e555f96d24aab2d9d562ddb0448367f27b2826762d28606277fa6c5c524b1f" => :arm64_big_sur
    sha256 "7921be487e39c42ddfda4e2c002ddd435df5f1032adf3df6c67bed61a74715d5" => :catalina
    sha256 "f14593656cf3c2b33728b1526239b617ab37d90dcfb36313c47a6f55d58dece4" => :mojave
    sha256 "eaf79f5145f08ff3fecb53b53dd4b061c3bf62910c702f5b5d433ebfebcf70ea" => :high_sierra
  end

  depends_on "python@3.9"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/40/a7/ded59fa294b85ca206082306bba75469a38ea1c7d44ea7e1d64f5443d67a/certifi-2020.6.20.tar.gz"
    sha256 "5930595817496dd21bb8dc35dad090f1c2cd0adfaf21204bf6732ca5d8ee34d3"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/2f/e0/3d435b34abd2d62e8206171892f174b180cd37b09d57b924ca5c2ef2219d/docutils-0.16.tar.gz"
    sha256 "c2de3a60e9e7d07be26b7f2b00ca0309c207e06c100f9cc2a94931fc75a478fc"
  end

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/0e/b9/040baf94b40c80081bbecbd90365a5d7765a1c07e31b6c949838cc4c93d1/flit_core-3.0.0.tar.gz"
    sha256 "a465052057e2d6d957e6850e9915245adedfc4fd0dd5737d0791bf3132417c2d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "pytoml" do
    url "https://files.pythonhosted.org/packages/f4/ba/98ee2054a2d7b8bebd367d442e089489250b6dc2aee558b000e961467212/pytoml-0.1.21.tar.gz"
    sha256 "8eecf7c8d0adcff3b375b09fe403407aa9b645c499e5ab8cac670ac4a35f61e7"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/da/67/672b422d9daf07365259958912ba533a0ecab839d4084c487a5fe9a5405f/requests-2.24.0.tar.gz"
    sha256 "b3559a131db72c33ee969480840fff4bb6dd111de7dd27c8ee1f820f4f00231b"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/81/f4/87467aeb3afc4a6056e1fe86626d259ab97e1213b1dfec14c7cb5f538bf0/urllib3-1.25.10.tar.gz"
    sha256 "91056c15fa70756691db97756772bb1eb9678fa585d9184f24534b100dc60f4a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"sample.py").write <<~END
      """A sample package"""
      __version__ = "0.1"
    END
    (testpath/"pyproject.toml").write <<~END
      [build-system]
      requires = ["flit_core"]
      build-backend = "flit_core.buildapi"

      [tool.flit.metadata]
      module = "sample"
      author = "Sample Author"
    END
    system bin/"flit", "build"
    assert_predicate testpath/"dist/sample-0.1-py2.py3-none-any.whl", :exist?
    assert_predicate testpath/"dist/sample-0.1.tar.gz", :exist?
  end
end
