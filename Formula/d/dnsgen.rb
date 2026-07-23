class Dnsgen < Formula
  include Language::Python::Virtualenv

  desc "Generates DNS names from existing domain names"
  homepage "https://github.com/AlephNullSK/dnsgen"
  url "https://files.pythonhosted.org/packages/5f/e1/1c7d86f51da5b93f3f99ac99e3ad051ed82234147ddd869f77a3959e6abc/dnsgen-1.0.4.tar.gz"
  sha256 "1087e9e5c323918aa3511e592759716116a208012aee024ffdbeac5fce573a0c"
  license "MIT"
  revision 9
  head "https://github.com/AlephNullSK/dnsgen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d293886619246d2e35fa0b83f04fb02f0684387171b17bf3e9bd48cda25c0d6d"
  end

  depends_on "certifi"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/23/e4/796662cd90cf80e3a363c99db2b88e0e394b988a575f60a17e16440cd011/click-8.4.0.tar.gz"
    sha256 "638f1338fe1235c8f4e008e4a8a254fb5c5fbdcbb40ece3c9142ebb78e792973"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/b5/fe/997687a931ab51049acce6fa1f23e8f01216374ea81374ddee763c493db5/filelock-3.29.0.tar.gz"
    sha256 "69974355e960702e789734cb4871f884ea6fe50bd8404051a3530bc07809cf90"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/82/77/7b3966d0b9d1d31a36ddf1746926a11dface89a83409bf1483f0237aa758/idna-3.15.tar.gz"
    sha256 "ca962446ea538f7092a95e057da437618e886f4d349216d2b1e294abfdb65fdc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/3c/f8/5dc70102e4d337063452c82e1f0d95e39abfe67aa222ed8a5ddeb9df8de8/requests_file-3.0.1.tar.gz"
    sha256 "f14243d7796c588f3521bd423c5dea2ee4cc730e54a3cac9574d78aca1272576"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/65/7b/644fbbb49564a6cb124a8582013315a41148dba2f72209bba14a84242bf0/tldextract-5.3.1.tar.gz"
    sha256 "a72756ca170b2510315076383ea2993478f7da6f897eef1f4a5400735d5057fb"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
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
