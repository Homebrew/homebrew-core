class Flit < Formula
  include Language::Python::Virtualenv

  desc "Simplified packaging of Python modules"
  homepage "https://github.com/takluyver/flit"
  url "https://files.pythonhosted.org/packages/ec/f8/b5c50a8567786375051e4e9ae31eb1141499506bcab297045429edfb4976/flit-3.4.0.tar.gz"
  sha256 "390288b27d89a084a32fc40020ad953e14bc215c5a01e6eb6ab8c9bdbcc57283"
  license "BSD-3-Clause"
  head "https://github.com/takluyver/flit.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6ba8051e7aaf5899c5076f2edb6d06e13bf6c5eb706d565034a076e7a5f017a7"
    sha256 cellar: :any_skip_relocation, big_sur:       "d3aa6e214b1681f59acf29e1006e62a141e8f8e3fdc8644e4a0977dc157eacfe"
    sha256 cellar: :any_skip_relocation, catalina:      "1f2a706002fc90761fa2f5f46d638e4cc88225fccd49f31d85919f5d3b692400"
    sha256 cellar: :any_skip_relocation, mojave:        "f92d7c5f0f23fa08dadd09c261bb44355152faa0e72c096352d8afffe05ef153"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "968497ab4885ce518bd4e37c4563a82608cdada9b8c4de3a55b9ce8daea2b2a7"
  end

  depends_on "python@3.10"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/eb/7f/a6c278746ddbd7094b019b08d1b2187101b1f596f35f81dc27f57d8fcf7c/charset-normalizer-2.0.6.tar.gz"
    sha256 "5ec46d183433dcbd0ab716f2d7f29d8dee50505b3fdb40c6b985c7c4f5a3591f"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/4c/17/559b4d020f4b46e0287a2eddf2d8ebf76318fd3bd495f1625414b052fdc9/docutils-0.17.1.tar.gz"
    sha256 "686577d2e4c32380bb50cbb22f575ed742d58168cee37e99117a854bcd88f125"
  end

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/2c/a9/64406cf5c1c31186e1208a290ff10a0add43882edaef5eeba49e15ba6e7f/flit_core-3.4.0.tar.gz"
    sha256 "29468fa2330969167d1f5c23eb9c0661cb6dacfcd46f361a274609a7f4197530"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/38/4c4d00ddfa48abe616d7e572e02a04273603db446975ab46bbcd36552005/idna-3.2.tar.gz"
    sha256 "467fbad99067910785144ce333826c71fb0e63a425657295239737f7ecd125f3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/75/50/973397c5ba854445bcc396b593b5db1958da6ab8d665b27397daa1497018/tomli-1.2.1.tar.gz"
    sha256 "a5b75cb6f3968abb47af1b40c1819dc519ea82bcc065776a866e8d74c5ca9442"
  end

  resource "tomli_w" do
    url "https://files.pythonhosted.org/packages/46/12/61ed2aa21bb7207ccce71eb3741623ce8a9adb99e034893a21ef5cc154d9/tomli_w-0.3.0.tar.gz"
    sha256 "207c5f05803aec5a9a578c6aca5c1bbbba9783ad88461f3e180eb8c3c3c48a4b"
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
