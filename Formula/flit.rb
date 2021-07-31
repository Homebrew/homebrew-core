class Flit < Formula
  include Language::Python::Virtualenv

  desc "Simplified packaging of Python modules"
  homepage "https://github.com/takluyver/flit"
  url "https://files.pythonhosted.org/packages/b6/86/4f55f5476c1b4aeb8825e4dcac71038b60bad8feb9d3635b5ecfcbbf98dd/flit-3.3.0.tar.gz"
  sha256 "65fbe22aaa7f880b776b20814bd80b0afbf91d1f95b17235b608aa256325ce57"
  license "BSD-3-Clause"
  head "https://github.com/takluyver/flit.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f9280b652b52747e4b82147c508a647da8b9b4ace9a891ce510e114505aacc06"
    sha256 cellar: :any_skip_relocation, big_sur:       "480b8a9e38bc0cc138e4126050cec057e23bcc0c182dd4e8bdef93a12d4abf73"
    sha256 cellar: :any_skip_relocation, catalina:      "2e9c13b0e9282ced640492fba6728e01db033fe423677b6900cebfefa83ee91b"
    sha256 cellar: :any_skip_relocation, mojave:        "768228404e6a0bd7576c338517387b987ed968ae8beef3b2cbb896b4e8cac52d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea9acbab6a6e4f0a3fb69ca418c0689b8173503c5a7c124398de7e8d00e2ba46"
  end

  depends_on "python@3.9"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/4e/2af0238001648ded297fb54ceb425ca26faa15b341b4fac5371d3938666e/charset-normalizer-2.0.4.tar.gz"
    sha256 "f23667ebe1084be45f6ae0538e4a5a865206544097e4e8bbcacf42cd02a348f3"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/4c/17/559b4d020f4b46e0287a2eddf2d8ebf76318fd3bd495f1625414b052fdc9/docutils-0.17.1.tar.gz"
    sha256 "686577d2e4c32380bb50cbb22f575ed742d58168cee37e99117a854bcd88f125"
  end

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/6f/cd/3653de7b1d61f0ef95f2459ac752f23a91dbc84f991787201aa52d0cf1cc/flit_core-3.3.0.tar.gz"
    sha256 "b1404accffd6504b5f24eeca9ec5d3c877f828d16825348ba81515fa084bd5f0"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/38/4c4d00ddfa48abe616d7e572e02a04273603db446975ab46bbcd36552005/idna-3.2.tar.gz"
    sha256 "467fbad99067910785144ce333826c71fb0e63a425657295239737f7ecd125f3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/4f/5a/597ef5911cb8919efe4d86206aa8b2658616d676a7088f0825ca08bd7cb8/urllib3-1.26.6.tar.gz"
    sha256 "f57b4c16c62fa2760b7e3d97c35b255512fb6b59a259730f36ba32ce9f8e342f"
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
