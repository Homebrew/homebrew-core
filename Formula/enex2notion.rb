class Enex2notion < Formula
  include Language::Python::Virtualenv

  desc "Import Evernote ENEX files to Notion"
  homepage "https://github.com/vzhd1701/enex2notion"
  url "https://files.pythonhosted.org/packages/bc/bd/8e6be68ee1be77dbcab9daad66f47526d4b569b98cceebbe686b8e341b50/enex2notion-0.2.25.tar.gz"
  sha256 "90b82462aac993b0553a5e6532bd72a2f40d17629d76ced47a442becf53da1f2"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91021c17492908fdfb02d5b333d21b5e7ee4cd8de52777584dd163438df5f4e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "749a1dd0c4b5e319bf6039cbca24287c6065fbb3649781e202a799b3fb782f77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0213feec646744f66442d2c3d0c27218e2a171ae89a593981989daf69217d0f2"
    sha256 cellar: :any_skip_relocation, ventura:        "cdf5a1e46ae8dc905bc743dbba1bfaeae14c72f8ebfce9c2cf2d37824fe60f22"
    sha256 cellar: :any_skip_relocation, monterey:       "aae6843f1016f4ac62635585bbfa1363ea0edff68f9a769e70004bc0b92db54a"
    sha256 cellar: :any_skip_relocation, big_sur:        "6665e8f71a63999c07d21388dcf9225c5f37f4ffadb51d1d38ecf1e919a529e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41ea9aa3c8d2860e75c14f7cc0dc292536a96a130b22a68c041521f20e959950"
  end

  depends_on "pymupdf"
  depends_on "python@3.11"
  depends_on "six"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/75/f8/de84282681c5a8307f3fff67b64641627b2652752d49d9222b77400d02b8/beautifulsoup4-4.11.2.tar.gz"
    sha256 "bc4bdda6717de5a2987436fb8d72f45dc90dd856bdfd512a1314ce90349a0106"
  end

  resource "bs4" do
    url "https://files.pythonhosted.org/packages/10/ed/7e8b97591f6f456174139ec089c769f89a94a1a4025fe967691de971f314/bs4-0.0.1.tar.gz"
    sha256 "36ecea1fd7cc5c0c6e4a1ff075df26d50da647b75376626cc186e2212886dd3a"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/61/2c/d21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41/cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/96/d7/1675d9089a1f4677df5eb29c3f8b064aa1e70c1251a0a8a127803158942d/charset-normalizer-3.0.1.tar.gz"
    sha256 "ebea339af930f8ca5d7a699b921106c6e29c617fe9606fa7baa043c1cdae326f"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "dictdiffer" do
    url "https://files.pythonhosted.org/packages/61/7b/35cbccb7effc5d7e40f4c55e2b79399e1853041997fcda15c9ff160abba0/dictdiffer-0.9.0.tar.gz"
    sha256 "17bacf5fbfe613ccf1b6d512bd766e6b21fb798822a133aa86098b8ac9997578"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "notion-vzhd1701-fork" do
    url "https://files.pythonhosted.org/packages/22/de/bf39964ff563671e066dce64d7503b9f693aa1a650234bb164be3a540e64/notion-vzhd1701-fork-0.0.36.tar.gz"
    sha256 "343bfa8d1e720ca6a4d7ad1caf20e3958f9026f567fc19bf02b96f5827c98710"
  end

  resource "pdfkit" do
    url "https://files.pythonhosted.org/packages/58/bb/6ddc62b4622776a6514fd749041c2b4bccd343e006d00de590f8090ac8b1/pdfkit-1.0.0.tar.gz"
    sha256 "992f821e1e18fc8a0e701ecae24b51a2d598296a180caee0a24c0af181da02a9"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
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
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/f3/03/bac179d539362319b4779a00764e95f7542f4920084163db6b0fd4742d38/soupsieve-2.3.2.post1.tar.gz"
    sha256 "fc53893b3da2c33de295667a0e19f078c14bf86544af307354de5fcf12a3f30d"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "tinycss2" do
    url "https://files.pythonhosted.org/packages/75/be/24179dfaa1d742c9365cbd0e3f0edc5d3aa3abad415a2327c5a6ff8ca077/tinycss2-1.2.1.tar.gz"
    sha256 "8cff3a8f066c2ec677c06dbc7b45619804a6938478d9d73c284b29d14ecb0627"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/c1/c2/d8a40e5363fb01806870e444fc1d066282743292ff32a9da54af51ce36a2/tqdm-4.64.1.tar.gz"
    sha256 "5f4f682a004951c1b450bc753c710e9280c5746ce6ffedee253ddbcbf54cf1e4"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/5b/30/b7abfb11be6642d26de1c1840d25e8d90333513350ad0ebc03101d55e13b/tzdata-2022.7.tar.gz"
    sha256 "fe5f866eddd8b96e9fcba978f8e503c909b19ea7efda11e52e39494bad3a7bfa"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/7d/b9/164d5f510e0547ae92280d0ca4a90407a15625901afbb9f57a19d9acd9eb/tzlocal-4.2.tar.gz"
    sha256 "ee5842fa3a795f023514ac2d801c4a81d1743bbe642e3940143326b3a00addd7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  resource "w3lib" do
    url "https://files.pythonhosted.org/packages/5e/2f/76558d2712d93e9267a3160190f1bb005f97ef4aba35592728f63747da8b/w3lib-1.22.0.tar.gz"
    sha256 "0ad6d0203157d61149fd45aaed2e24f53902989c32fc1dccc2e2bfba371560df"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
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
