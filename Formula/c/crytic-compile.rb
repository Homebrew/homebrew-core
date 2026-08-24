class CryticCompile < Formula
  include Language::Python::Virtualenv

  desc "Abstraction layer for smart contract build systems"
  homepage "https://github.com/crytic/crytic-compile"
  url "https://files.pythonhosted.org/packages/d3/c1/ba7f089fbf73cef1f1684d8fb5ec7c47d6f81870ca3e21b32aed88196774/crytic_compile-0.4.2.tar.gz"
  sha256 "161325e40785d8e42cdd8846b98d4f82c291ca5bcd07b5feae1a84d5a18c59fb"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/crytic-compile.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a7859bee32195b143413e349a006182976b2e8036566ce0b61bbc59bd6f13d41"
    sha256 cellar: :any, arm64_sequoia: "b968200aefdcfead937e15b050edbdcc994a69f8bafa31be7e448da80a1fce98"
    sha256 cellar: :any, arm64_sonoma:  "f937e57d8493b2f07db32eb3c231e571333dfc139b2a32c68be47aa3375153a5"
    sha256 cellar: :any, sonoma:        "7be5628fb00002fa12f63198cc787826e3a0ff3e5ce76d82c44f5670f6de5144"
    sha256 cellar: :any, arm64_linux:   "d2c040cd938e01ad7317df3749c13fb7eb938c0d127c8daeb7ede6c080f75735"
    sha256 cellar: :any, x86_64_linux:  "33cbac6b9602486840c3a770b5837baa8dcbf0eb2877cae746f3c9b5c2577f11"
  end

  depends_on "rust" => :build # for `cbor2`
  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/3a/6f/07b4af8da8bd27f640362b1ac8271d80895407f2ede0c2bcc9433c06e1ca/cbor2-6.1.3.tar.gz"
    sha256 "8d70680acb55c04ea5b5ad86da094f9612b53d5a8a65d0f5b3aafc3ce917ecbb"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/bd/2a/23f34ec9d04624958e137efdc394888716353190e75f25dd22c7a2c7a8aa/charset_normalizer-3.4.9.tar.gz"
    sha256 "673611bbd43f0810bec0b0f028ddeaaa501190339cac411f347ac76917c3ae7b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/8e/a6/8452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5/pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "solc-select" do
    url "https://files.pythonhosted.org/packages/62/89/51e614fdbf26f47268c18f8a3b6cf1cb67c9a8b48b7b7231c948cae97814/solc_select-1.2.0.tar.gz"
    sha256 "ad0a7afcae05061ce5e7632950b1fa0193ba9eaf05e4956f86effee024c6fb07"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "testdata" do
      url "https://github.com/crytic/slither/raw/d0a4f5595d7177b3b7d4bd35e1384bf35ebc22d4/tests/ast-parsing/compile/variable-0.8.0.sol-0.8.15-compact.zip", using: :nounzip
      sha256 "2f165f629882d0250d03a56cb67a84e9741375349195915a04385b0666394478"
    end

    resource("testdata").stage do
      system bin/"crytic-compile", "variable-0.8.0.sol-0.8.15-compact.zip",
             "--export-format=solc", "--export-dir=#{testpath}/export"
    end

    assert_path_exists testpath/"export/combined_solc.json"
  end
end
