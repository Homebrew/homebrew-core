class Pdfly < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to extract (meta)data from PDF and manipulate PDF files"
  homepage "https://pdfly.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/48/ae/70f161c80b3f39d8fe4ff784c78045225820d10375c81c2097c0e85ac0fc/pdfly-0.5.1.tar.gz"
  sha256 "636e9736ca3296ed69ad7e14d997813ea5a662ba7a86c77d155e343494dcc3d7"
  license "BSD-3-Clause"
  revision 25

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ff161411dcea7e1c35ae078c366dbf649755f677713ca79347d38a49967b838f"
    sha256 cellar: :any, arm64_tahoe:       "1f8b3c807e25bcfe305f3e3ba388a980b3abb51d71b88e31ae6d0a9443ee1020"
    sha256 cellar: :any, arm64_sequoia:     "42033aa8c32c70626fad199c927cfa750b0b0d829a8685d2e663439e7b69e618"
    sha256 cellar: :any, arm64_sonoma:      "11ea55b8a9a2e301d20e6fccd6a721924524264dfac68012d8ba038e965e2c15"
    sha256 cellar: :any, arm64_linux:       "c92d2b5b3dec8420b260c4ddf86c7ba7cdf43b34c2a6fb991f84ffbdd19352b5"
    sha256 cellar: :any, x86_64_linux:      "ed8be298b03285aebc8e87830b2199d0683c1da717b8aea9cb40554e847e159c"
  end

  # `pkgconf` and `rust` are for bcrypt
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "pillow" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

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

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
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
    url "https://files.pythonhosted.org/packages/d4/41/0f072a712dc74496e03710e462a18a4cfd8a258ad055a4e22d28b43a7abd/fonttools-4.64.0.tar.gz"
    sha256 "ecb2e59a7bc692fee64dda6010deb66222335693b30046f15cccf81233aa715f"
  end

  resource "fpdf2" do
    url "https://files.pythonhosted.org/packages/1e/bc/8fd4321aed40cadadddc8f311c65b6082346b252bca048f7b476d8f35d72/fpdf2-2.8.8.tar.gz"
    sha256 "9e94e155e85e8053329a9a1fce8b566fd7a7c5bb79e98a1a3952d379b947c5b9"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/5f/f7/abb373e5757eaec4b922b92f97ec8d6d7e057cf06778247604fbc4e7c3f3/idna-3.19.tar.gz"
    sha256 "5e0811a4383b21dc5838069f801c4fb62113b7447663d2530d2bd6e77b49bf15"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/33/f6/227c48c5fe47fa178ccf1fda8f047d16c97ba926567b661e9ce2045c600c/invoke-3.0.3.tar.gz"
    sha256 "437b6a622223824380bfb4e64f612711a6b648c795f565efc8625af66fb57f0c"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/ad/a9/970b8fa0ecc4fbf1dfaed0d89bbc1fc1421b25ec26a2038c91e872dc6c8e/lxml-6.1.2.tar.gz"
    sha256 "1055241852f2b02068af4a625a5d32c087db193c12251928af2562ecd2239f18"
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
    url "https://files.pythonhosted.org/packages/6a/eb/72988605cd3c5aa102f5a92ceab27acdb248a0998ea507ce2e9a29071af0/pykcs11-1.5.19.tar.gz"
    sha256 "07f50ef9d7a60a5408edfe8d1186f1f4cf7605fc2eb720176ae239734faba0f0"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/d9/9a/4019b524b03a13438637b11538c82781a5eda427394380381af8f04f467a/pynacl-1.6.2.tar.gz"
    sha256 "018494d6d696ae03c7e656e5e74cdfd8ea1326962cc401bcf018f1ed8436811c"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/44/66/54212e75406afd9f3e933d0dda23072f6aecc55c5a273077dc2e0b028b23/pypdf-6.16.2.tar.gz"
    sha256 "595647f6191de6f402cfde1d0c455d6cbccbd509aac32b34783009c032de5d6e"
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
    url "https://files.pythonhosted.org/packages/16/f7/57713ba479fd405eb76de31404b2c744c289e336b2d999511ebf51e496f7/typer-0.27.2.tar.gz"
    sha256 "269b7eb9d3c202ca84b4bc9618cb04ebb43d3d4d1e567e4c768607232c05f945"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
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
