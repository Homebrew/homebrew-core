class Pdfly < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to extract (meta)data from PDF and manipulate PDF files"
  homepage "https://pdfly.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/48/ae/70f161c80b3f39d8fe4ff784c78045225820d10375c81c2097c0e85ac0fc/pdfly-0.5.1.tar.gz"
  sha256 "636e9736ca3296ed69ad7e14d997813ea5a662ba7a86c77d155e343494dcc3d7"
  license "BSD-3-Clause"
  revision 26

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "030625a8002cafbead6b342bac3f55f9ceb367b8dfcb0cba3da256a14b268448"
    sha256 cellar: :any, arm64_tahoe:       "ff9d9fcc8fb0713cc3b317a9999773b0c760ab771f3ca124a4b62c713090f664"
    sha256 cellar: :any, arm64_sequoia:     "9564114a56de581fa3a57d3ebb4866ae407aa14e591b229359d2cd09e8a888ae"
    sha256 cellar: :any, arm64_linux:       "4c2d393edd792e793d5eaf1c77b163558e4a3a4fa87c53a0046ae010950fb3e4"
    sha256 cellar: :any, x86_64_linux:      "96267370c99deb2eec1a32636f70611db216194e063e22648edbd6ac04e9ea45"
  end

  # `pkgconf` and `rust` are for bcrypt
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libsodium"
  depends_on "pillow" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"

  uses_from_macos "m4" => :build
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: %w[certifi cryptography pillow pydantic]

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/5a/8e/38aa427ed5402449e226975b649c5dc73ccadfefeb95e6aecb8f8ea4b6b6/annotated_doc-0.0.5.tar.gz"
    sha256 "c7e58ce09192557605d8bbd92836d7e1d520ac9580096042c0bfd197efacf1bb"
  end

  resource "arabic-reshaper" do
    url "https://files.pythonhosted.org/packages/f2/6c/6be41c689bd2f6e9274c77bf45be820e41ff1ecb9ab0a1d23964b6d04606/arabic_reshaper-3.0.1.tar.gz"
    sha256 "a0d9b2a9fa29b5f2c1d705f407adf6ca4242405b9cac0e5cc09e6c4f3f8fb68c"
  end

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/de/cf/d547feed25b5244fcb9392e288ff9fdc3280b10260362fc45d37a798a6ee/asn1crypto-1.5.1.tar.gz"
    sha256 "13ae38502be632115abf8a24cbe5f4da52e3b5231990aff31123c805306ccb9c"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d4/36/3329e2518d70ad8e2e5817d5a4cac6bba05a47767ec416c7d020a965f408/bcrypt-5.0.0.tar.gz"
    sha256 "f748f7c2d6fd375cc93d3fba7ef4a9e3a092421b8dbf34d8d4dc06be9492dfdd"
  end

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/f7/16/c92ca344d646e71a43b8bb353f0a6490d7f6e06210f8554c8f874e454285/brotli-1.2.0.tar.gz"
    sha256 "e310f77e41941c13340a95976fe66a8a95b01e783d430eeaf7a2f87e0a57dd0a"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "endesive" do
    url "https://files.pythonhosted.org/packages/a0/c3/a0dcae019de40816352462371c473b22639cd8e68f33a5f23f07faf330fd/endesive-2.19.3-py3-none-any.whl"
    sha256 "e5e09c1011b1977fbb9d563d672de7f17f5638304ce57a35bf7d00f3b7a3972e"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/87/b6/126c659ab7e0e03e01a5f5d223abf7b2c0691ae92718085a212a3924a2a3/fonttools-4.66.1.tar.gz"
    sha256 "64967c6ddb0d4c610dfd8cb1485981b2d27972ddfb7d4bbbd9e199d2a089c450"
  end

  resource "fpdf2" do
    url "https://files.pythonhosted.org/packages/12/23/84dbe637708c2690972eff5df233a7c9f8d4bde809f714839dc1b08f5e5e/fpdf2-2.8.9.tar.gz"
    sha256 "5b0b3786f5236a2b3cc83c1fee567df17ddd314f8c4e13d820d8f09b617ab4f0"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/33/f6/227c48c5fe47fa178ccf1fda8f047d16c97ba926567b661e9ce2045c600c/invoke-3.0.3.tar.gz"
    sha256 "437b6a622223824380bfb4e64f612711a6b648c795f565efc8625af66fb57f0c"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/62/93/dcc25d52f49022ae6175d15e6bd751f1acc99b98bc61fc55e5155a7be2e7/paramiko-5.0.0.tar.gz"
    sha256 "36763b5b95c2a0dcfdf1abc48e48156ee425b21efe2f0e787c2dd5a95c0e5e79"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pykcs11" do
    url "https://files.pythonhosted.org/packages/9a/7f/caf69dafa28ce1d255bf719c0d5e38edc448b08d9847c8b1143fa2d6e503/pykcs11-1.5.20.tar.gz"
    sha256 "1f7a7c8164fac636382aa7b0d70279ad5581379748fc17a20bc0be8fe574c259"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/d9/9a/4019b524b03a13438637b11538c82781a5eda427394380381af8f04f467a/pynacl-1.6.2.tar.gz"
    sha256 "018494d6d696ae03c7e656e5e74cdfd8ea1326962cc401bcf018f1ed8436811c"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/45/7e/d08c72b29e89b1ad14acaae817685ca06bac93691bddfd4fac08a703e5b0/pypdf-6.20.0.tar.gz"
    sha256 "72b1e897fef7f5bbed7f2a93881a4861d98dbf25ae39981c8a023583239edbda"
  end

  resource "python-bidi" do
    url "https://files.pythonhosted.org/packages/ce/e7/f168f2c3151aa05b9f9c9b2f7767bc8e06a133ea822c231ab497d4f36833/python_bidi-0.6.11.tar.gz"
    sha256 "034090c597af250d699299d7e7f1e83eb016f9e47b3b707bd89ab2bdec77bce0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/03/51/d33db42cc72ffd8c30777547b42d01f0cbf9d95a770457698d0174b3ed71/typer-0.27.3.tar.gz"
    sha256 "d0396f770a560ab1b0a8504e13b5f254b728cedb05c61cf0359e944e50ce8901"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  def install
    # Turn on shell completions option
    inreplace "pdfly/cli.py", "add_completion=False", "add_completion=True"

    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"pdfly", shell_parameter_format: :typer)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdfly --version")

    test_pdf = test_fixtures("test.pdf")
    assert_match <<~EOS, shell_output("#{bin}/pdfly meta #{test_pdf}")
      ┏━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━┓
      ┃          Attribute ┃ Value              ┃
      ┡━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━┩
      │              Pages │ 1                  │
      │          Encrypted │ None               │
      │   PDF File Version │ %PDF-1.6           │
      │        Page Layout │                    │
      │          Page Mode │                    │
      │             PDF ID │ ID1=None ID2=None  │
      │ Fonts (unembedded) │ /Helvetica         │
      │   Fonts (embedded) │                    │
      │        Attachments │ []                 │
      │             Images │ 0 images (0 bytes) │
      └────────────────────┴────────────────────┘
    EOS
  end
end
