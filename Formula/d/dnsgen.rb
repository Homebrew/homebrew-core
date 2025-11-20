class Dnsgen < Formula
  include Language::Python::Virtualenv

  desc "Generates DNS names from existing domain names"
  homepage "https://github.com/AlephNullSK/dnsgen"
  url "https://files.pythonhosted.org/packages/5f/e1/1c7d86f51da5b93f3f99ac99e3ad051ed82234147ddd869f77a3959e6abc/dnsgen-1.0.4.tar.gz"
  sha256 "1087e9e5c323918aa3511e592759716116a208012aee024ffdbeac5fce573a0c"
  license "MIT"
  revision 2
  head "https://github.com/AlephNullSK/dnsgen.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "15b50f2cc4aced4a85f39d295a40c8fc7ee42c9bf1259beabd582c625c73fbbd"
  end

  depends_on "certifi"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/58/46/0028a82567109b5ef6e4d2a1f04a583fb513e6cf9527fcdd09afd817deeb/filelock-3.20.0.tar.gz"
    sha256 "711e943b4ec6be42e1d4e6690b48dc175c822967466bb31c0c293f34334c13f4"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/72/97/bf44e6c6bd8ddbb99943baf7ba8b1a8485bcd2fe0e55e5708d7fee4ff1ae/requests_file-2.1.0.tar.gz"
    sha256 "0f549a3f3b0699415ac04d167e9cb39bccfb730cb832b4d20be3d9867356e658"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/97/78/182641ea38e3cfd56e9c7b3c0d48a53d432eea755003aa544af96403d4ac/tldextract-5.3.0.tar.gz"
    sha256 "b3d2b70a1594a0ecfa6967d57251527d58e00bb5a91a74387baa0d87a0678609"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"dnsgen", shell_parameter_format: :click)
  end

  test do
    (testpath/"domains.txt").write <<~EOS
      example.com
      example.net
    EOS

    output = shell_output("#{bin}/dnsgen domains.txt")
    assert_match "beta.example.com", output
  end
end
