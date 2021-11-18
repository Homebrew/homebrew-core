class Flit < Formula
  include Language::Python::Virtualenv

  desc "Simplified packaging of Python modules"
  homepage "https://github.com/takluyver/flit"
  url "https://files.pythonhosted.org/packages/86/e2/6501c2a722e106c0eac94f441074c3c34effc34ce1b5416a28b087030cd9/flit-3.5.0.tar.gz"
  sha256 "7b55f406ee5c1505f463cd9a186c73d2ccaf7d44618ca59ae643e0dce27cadf7"
  license "BSD-3-Clause"
  head "https://github.com/takluyver/flit.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "846457464bf2329df84cda18bac27bb7b3e256eb7777ef5f80b1905fa6aba7fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ba8051e7aaf5899c5076f2edb6d06e13bf6c5eb706d565034a076e7a5f017a7"
    sha256 cellar: :any_skip_relocation, monterey:       "a694281030011eb164805b4bbe128b7099f66effff01eccea33a6b38540476ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3aa6e214b1681f59acf29e1006e62a141e8f8e3fdc8644e4a0977dc157eacfe"
    sha256 cellar: :any_skip_relocation, catalina:       "1f2a706002fc90761fa2f5f46d638e4cc88225fccd49f31d85919f5d3b692400"
    sha256 cellar: :any_skip_relocation, mojave:         "f92d7c5f0f23fa08dadd09c261bb44355152faa0e72c096352d8afffe05ef153"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "968497ab4885ce518bd4e37c4563a82608cdada9b8c4de3a55b9ce8daea2b2a7"
  end

  depends_on "python@3.10"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/9f/c5/334c019f92c26e59637bb42bd14a190428874b2b2de75a355da394cf16c1/charset-normalizer-2.0.7.tar.gz"
    sha256 "e019de665e2bcf9c2b64e2e5aa025fa991da8720daa3c1138cadd2fd1856aed0"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/61/d7/8b2786f10b73e546aa9a85c2791393a6f475a16771b8028c7fb93d6ac8ce/docutils-0.18.tar.gz"
    sha256 "c1d5dab2b11d16397406a282e53953fe495a46d69ae329f55aa98a5c4e3c5fbb"
  end

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/26/12/74c9b72b280006a97fb80268e6b84bf77c73837d93391c8238488c6f2dde/flit_core-3.5.0.tar.gz"
    sha256 "2db800d33ff41e4c6e7c1b594666cb2a11553024106655272c7245933b1d75bd"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/aa/5b/62165da80cbc6e1779f342234c7ddc6c6bc9e64cef149046a9c0456f912b/tomli-1.2.2.tar.gz"
    sha256 "c6ce0015eb38820eaf32b5db832dbc26deb3dd427bd5f6556cf0acac2c214fee"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/25/38/03080644f9b3392954b62ace2b44162dadb0493946a791233804f9a69539/tomli_w-0.4.0.tar.gz"
    sha256 "47643abe03b628b6e214c38cf0816dca7b63888e503ec8580d251e331c0526b6"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
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
