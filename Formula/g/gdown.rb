class Gdown < Formula
  include Language::Python::Virtualenv

  desc "Google Drive Public File Downloader when Curl/Wget Fails"
  homepage "https://github.com/wkentaro/gdown"
  url "https://files.pythonhosted.org/packages/59/f4/230085dfb665cb944c73848de4bddc5dbc99c1573e18fb897863adedacaa/gdown-6.5.2.tar.gz"
  sha256 "d372ee7e19fb521eccdc3fa9c77b38ce0591d86b83edb7b151835417afeb162f"
  license "MIT"
  head "https://github.com/wkentaro/gdown.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2bb32da450666386a6130c1cecc0abe3269cdd92d1e5739b5b54a21dd72aab98"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2bb32da450666386a6130c1cecc0abe3269cdd92d1e5739b5b54a21dd72aab98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2bb32da450666386a6130c1cecc0abe3269cdd92d1e5739b5b54a21dd72aab98"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "88bf6f2397b6287a277db9c9ef8324dc0051431a7c9d2a75a0e16cef9a808aa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "88bf6f2397b6287a277db9c9ef8324dc0051431a7c9d2a75a0e16cef9a808aa9"
  end

  depends_on "certifi"
  depends_on "python@3.15"

  pypi_packages exclude_packages: "certifi"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/43/65/318323f98dbee45d42dff61d8f047181bc6f2268a9068cfad035a46be5af/beautifulsoup4-4.15.0.tar.gz"
    sha256 "288e3ca7d54b06f2ac191970bc275c1939cb46d450b255bf6718b04aa37ab4f7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/52/aa/8ccff8da9a27e089727fcffd3c5b61708383217e47eb1e1b8af37b1dd166/filelock-4.2.12.tar.gz"
    sha256 "7e7da24d3ac39268b0f156e56870001de44886318f092f9d851e692f7114d6dd"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/1f/52/ee5646b65d98a252e807ccc37725363942372a4113072e0bce7ed22f8b84/soupsieve-4.1.1.tar.gz"
    sha256 "b296bd2d2f65b1a78149f3d7bf6736a147d2c9e2dfbde0e4404639d748a02e03"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gdown -V")
    system bin/"gdown", "https://drive.google.com/uc?id=0B9P1L--7Wd2vU3VUVlFnbTgtS2c"
    assert_path_exists "spam.txt"
  end
end
