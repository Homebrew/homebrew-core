class Enex2notion < Formula
  include Language::Python::Virtualenv

  desc "Import Evernote ENEX files to Notion"
  homepage "https://github.com/vzhd1701/enex2notion"
  url "https://files.pythonhosted.org/packages/de/5c/c0ce22d810226345411b03177f9b43c35b82c3a671d5d73f56fc43b0858e/enex2notion-0.3.1.tar.gz"
  sha256 "f11d8a7b6c135b4d08c63e1256279d56b3798cdd48ad3b6e39c0770dc3bd82e6"
  license "MIT"
  revision 22

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "005f6c3618b5783d8cf5eab769437d8ee6620a6e4d708aad3357eb2849b3c26e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e19141b7783f7dcdad8424f059f791273cfc7d580e048de336dab3d4213cc49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a1db037031086d61d7ae80892792ae2eab75ac2043c41d4904191a090b7c8f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1655e075fd07c279e295b9f80c17e0840a983ccd06ca293fbcde4556eb989e96"
    sha256 cellar: :any,                 arm64_linux:   "9d1134cad17ec53e1a690828c896de9406c5351b61487f211e0b443c5a001a50"
    sha256 cellar: :any,                 x86_64_linux:  "19cfb5d172f09091952386c223ebc7cd37bd3a350e9e9f5834c721fb1be4c1fd"
  end

  depends_on "certifi" => :no_linkage
  depends_on "pymupdf"
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: %w[certifi lxml pymupdf]

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/43/65/318323f98dbee45d42dff61d8f047181bc6f2268a9068cfad035a46be5af/beautifulsoup4-4.15.0.tar.gz"
    sha256 "288e3ca7d54b06f2ac191970bc275c1939cb46d450b255bf6718b04aa37ab4f7"
  end

  resource "bs4" do
    url "https://files.pythonhosted.org/packages/10/ed/7e8b97591f6f456174139ec089c769f89a94a1a4025fe967691de971f314/bs4-0.0.1.tar.gz"
    sha256 "36ecea1fd7cc5c0c6e4a1ff075df26d50da647b75376626cc186e2212886dd3a"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/61/2c/d21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41/cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/bd/2a/23f34ec9d04624958e137efdc394888716353190e75f25dd22c7a2c7a8aa/charset_normalizer-3.4.9.tar.gz"
    sha256 "673611bbd43f0810bec0b0f028ddeaaa501190339cac411f347ac76917c3ae7b"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/3e/e4/0800832e530c88a8f80cb9e486879ea74257062dfe03a38c1ad535c2860e/commonmark-0.9.2.tar.gz"
    sha256 "194d693e0c1ac49e83c26455bdeeb2483235e6280313c58b11d0b71c19f58ed1"
  end

  resource "dictdiffer" do
    url "https://files.pythonhosted.org/packages/61/7b/35cbccb7effc5d7e40f4c55e2b79399e1853041997fcda15c9ff160abba0/dictdiffer-0.9.0.tar.gz"
    sha256 "17bacf5fbfe613ccf1b6d512bd766e6b21fb798822a133aa86098b8ac9997578"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "notion-vzhd1701-fork" do
    url "https://files.pythonhosted.org/packages/77/5b/314816c876cae1dac143c3e0221a9b4b9b186576ef92e75e0aab041c179c/notion_vzhd1701_fork-0.0.37.tar.gz"
    sha256 "36bab3b5257a3019ada5b085d9c6f7d1f5d466d38bb8a089b850ce792fd561bc"
  end

  resource "pdfkit" do
    url "https://files.pythonhosted.org/packages/58/bb/6ddc62b4622776a6514fd749041c2b4bccd343e006d00de590f8090ac8b1/pdfkit-1.0.0.tar.gz"
    sha256 "992f821e1e18fc8a0e701ecae24b51a2d598296a180caee0a24c0af181da02a9"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/5d/45/915967d7bcc28fd12f36f554e1a64aeca36214f2be9caf87158168b5a575/python-slugify-6.1.2.tar.gz"
    sha256 "272d106cb31ab99b3496ba085e3fea0e9e76dcde967b5e9992500d1f785ce4e1"
  end

  resource "pytz-deprecation-shim" do
    url "https://files.pythonhosted.org/packages/94/f0/909f94fea74759654390a3e1a9e4e185b6cd9aa810e533e3586f39da3097/pytz_deprecation_shim-0.1.0.post0.tar.gz"
    sha256 "af097bae1b616dde5c5744441e2ddc69e74dfdcb0c263129610d85b87445a59d"
  end

  resource "ratelimit" do
    url "https://files.pythonhosted.org/packages/ab/38/ff60c8fc9e002d50d48822cc5095deb8ebbc5f91a6b8fdd9731c87a147c9/ratelimit-2.2.1.tar.gz"
    sha256 "af8a9b64b821529aca09ebaf6d8d279100d766f19e90b5059ac6a718ca6dee42"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/47/2c/0a5f6f8ee0d5589e48c7640213ed5175d52cf540a06725b628cc1a45d6ce/soupsieve-2.8.4.tar.gz"
    sha256 "e121fd02e975c695e4e9e8774a5ee35d74714b59307868dcc5319ad2d9e3328e"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "tinycss2" do
    url "https://files.pythonhosted.org/packages/a3/ae/2ca4913e5c0f09781d75482874c3a95db9105462a92ddd303c7d285d3df2/tinycss2-1.5.1.tar.gz"
    sha256 "d339d2b616ba90ccce58da8495a78f46e55d4d25f9fd71dfd526f07e7d53f957"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/ae/5f/57ff8b434839e70dab45601284ea413e947a63799891b7553e5960a793a8/tqdm-4.68.4.tar.gz"
    sha256 "19829c9673638f2a0b8617da4cdcb927e831cd88bcfcb6e78d42a4d1af131520"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/ba/19/1b9b0e29f30c6d35cb345486df41110984ea67ae69dddbc0e8a100999493/tzdata-2026.2.tar.gz"
    sha256 "9173fde7d80d9018e02a662e168e5a2d04f87c41ea174b139fbef642eda62d10"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/d7/33/68fe21c4a3ecf5e093b5179ea23be777037b1e83722f5559a1e2223d2422/tzlocal-4.3.1.tar.gz"
    sha256 "ee32ef8c20803c19a96ed366addd3d4a729ef6309cb5c7359a0cc2eeeb7fa46a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "w3lib" do
    url "https://files.pythonhosted.org/packages/c0/91/b2eb59c2cf243de5de1e91c963655df78c015509f51297685a8c86a27b8c/w3lib-2.4.1.tar.gz"
    sha256 "8dd69ee39ff6398d708c793abc779c334a69bac7cee1cdf71736c669ed6be864"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  # `lxml` is manually updated to support Python 3.14
  # Issue ref: https://github.com/vzhd1701/enex2notion/issues/126
  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"

    livecheck do
      skip "Skip until new release with compatible version"
    end
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.enex").write <<~EOF
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE en-export SYSTEM "http://xml.evernote.com/pub/evernote-export3.dtd">
      <en-export>
        <note>
          <title>Test</title>
          <content>
            <![CDATA[<?xml version="1.0" encoding="UTF-8" standalone="no"?>
              <!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
              <en-note><div><br /></div></en-note>
            ]]>
          </content>
        </note>
      </en-export>
    EOF

    assert_match "No token provided", shell_output("#{bin}/enex2notion test.enex 2>&1")

    assert_match version.to_s, shell_output("#{bin}/enex2notion --version")
  end
end
