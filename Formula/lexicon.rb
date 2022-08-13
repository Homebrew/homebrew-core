class Lexicon < Formula
  include Language::Python::Virtualenv

  desc "Manipulate DNS records on various DNS providers in a standardized way"
  homepage "https://github.com/AnalogJ/lexicon"
  url "https://files.pythonhosted.org/packages/76/9a/5fa6474f41188f17e1c58cc38bb12148882068dcc3271a113c8be18b1523/dns-lexicon-3.11.4.tar.gz"
  sha256 "eca3688a458bc59b9539591b90f6835cb0f90eccda56379b09d40345708fa3c6"
  license "MIT"
  head "https://github.com/AnalogJ/lexicon.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "78eb6f9ec1be3ba6d817fe8f5199892f5c7dea3b0dc7b019f86bdc306c5de06b"
    sha256 cellar: :any,                 arm64_big_sur:  "bcec5f11d735d1cfdbfd8285fd32f9a4079e17b4a8a05bf9b4b5fc96bfdfcc41"
    sha256 cellar: :any,                 monterey:       "447cc98e4e1cc15144b4dc874254b2fca90785f77fabdeb555284bacce453ee7"
    sha256 cellar: :any,                 big_sur:        "346dada1406d7bfc161bfd54880d7bef97facac2435d2999674f07eddcbc2811"
    sha256 cellar: :any,                 catalina:       "383e9250af2b3ead9a70edcdfba2c6feb1eede82305131e5baa91cb2ba72d107"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dbfd0cba0c7b5aef47d267fafaa6088e70056d93a140a516d9ef61f456c81bf"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "python@3.10"
  depends_on "six"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/e8/b0/cd2b968000577ec5ce6c741a54d846dfa402372369b8b6861720aa9ecea7/beautifulsoup4-4.11.1.tar.gz"
    sha256 "ad9aa55b65ef2808eb405f46cf74df7fcb7044d5cbc26487f96eb2ef2e436693"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/80/ca/c973f4cb2f0ccb54b4b61653fa8304701249aaa9589844ec48609a79a639/boto3-1.24.50.tar.gz"
    sha256 "28fefb77fb85b521a87ffd932621b14aabf4bb65ec4f9d9ce7399d093b2ad8bd"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/db/7c/1116dd55dee06d99d4ea304b9554fa1d8e78724fb40ed1259d2672b173bf/botocore-1.27.50.tar.gz"
    sha256 "0a3e2eef7a60c20e46be47eaf45cf5ea7a946aecdb68d829886d4f2506ac657c"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/61/2c/d21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41/cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cc/85/319a8a684e8ac6d87a1193090e06b6bbb302717496380e225ee10487c888/certifi-2022.6.15.tar.gz"
    sha256 "84c85a9078b11105f04f3036a9482ae10e4621616db313fe045dd24743a0820d"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/93/1d/d9392056df6670ae2a29fcb04cfa5cee9f6fbde7311a1bb511d4115e9b7a/charset-normalizer-2.1.0.tar.gz"
    sha256 "575e708016ff3a5e3681541cb9d79312c416835686d054a23accb873b254f413"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/02/a8/5fae273a45a3e4e34ea560c99a4843fe2d9fc6fb691de064dc9c72c46e57/configparser-5.2.0.tar.gz"
    sha256 "1b35798fdf1713f1c3139016cfcbc461f09edbf099d1fb658d4b7479fcaa3daa"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/89/d9/5fcd312d5cce0b4d7ee8b551a0ea99e4ea9db0fdbf6dd455a19042e3370b/cryptography-37.0.4.tar.gz"
    sha256 "63f9c17c0e2474ccbebc9302ce2f07b55b3b3fcb211ded18a42d5764f5c10a82"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/99/fb/e7cd35bba24295ad41abfdff30f6b4c271fd6ac70d20132fa503c3e768e0/dnspython-2.2.1.tar.gz"
    sha256 "0f7569a4a6ff151958b64304071d370daa3243d15941a7beedf0c9fe5105603e"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/95/55/b897882bffb8213456363e646bf9e9fa704ffda5a7d140edf935a9e02c7b/filelock-3.8.0.tar.gz"
    sha256 "55447caa666f2198c5b6b13a26d2084d26fa5b115c00d065664b2124680c4edc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/1a/16/441080c907df829016729e71d8bdd42d99b9bdde48b01492ed08912c0aa9/importlib_metadata-4.12.0.tar.gz"
    sha256 "637245b8bab2b6502fcbc752cc4b7a6f6243bb02b31c5c26156ad103d3d45670"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/db/7a/c0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1af/isodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "localzone" do
    url "https://files.pythonhosted.org/packages/f9/1a/2406e73b9dedafc761526687a60a09aaa8b0b2f2268aa084c56cbed81959/localzone-0.9.8.tar.gz"
    sha256 "23cb6b55a620868700b3f44e93d7402518e08eb7960935b3352ad3905c964597"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/70/bb/7a2c7b4f8f434aa1ee801704bf08f1e53d7b5feba3d5313ab17003477808/lxml-4.9.1.tar.gz"
    sha256 "fe749b052bb7233fe5d072fcb549221a8cb1a16725c47c37e42b0b9cb3ff2c3f"
  end

  resource "oci" do
    url "https://files.pythonhosted.org/packages/22/bd/59c6ca3a1789d377fdd7845e6ba0fb3de1618e0f900308285028d0b2a6ca/oci-2.9.0.tar.gz"
    sha256 "82be4b64456de3b0f7f8051e52d48c0c8b6c499c9c22661b454df459ab7a5632"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ff/7b/3613df51e6afbf2306fc2465671c03390229b55e3ef3ab9dd3f846a53be6/platformdirs-2.5.2.tar.gz"
    sha256 "58c8abb07dcb441e6ee4b11d8df0ac856038f944ab98b7be6b27b2a3c7feef19"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/10/88/ef38a6e4bc375600d3031e405a8d3b3dc4a154fccffd21d5d06e66c96230/prettytable-3.3.0.tar.gz"
    sha256 "118eb54fd2794049b810893653b20952349df6d3bc1764e7facd8a18064fa9b0"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/c5/7e/71693dc21d20464e4cd7c600f2d8fad1159601a42ed55566500272fe69b5/prompt_toolkit-3.0.30.tar.gz"
    sha256 "859b283c50bde45f5f97829f77a4674d1c1fcd88539364f1b28a37805cfd89c0"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/59/0f/eb10576eb73b5857bc22610cdfc59e424ced4004fe7132c8f2af2cc168d3/Pygments-2.12.0.tar.gz"
    sha256 "5eb116118f9612ff1ee89ac96437bb6b49e8f04d8a13b514ba26f620208e26eb"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/35/d3/d6a9610f19d943e198df502ae660c6b5acf84cc3bc421a2aa3c0fb6b21d1/pyOpenSSL-22.0.0.tar.gz"
    sha256 "660b1b1425aac4a1bea1d94168a85d99f0b3144c869dd4390d27629d0087f1bf"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/cf/80/8246892889a36f4a12f719da27c72faea1c2bdb6998afbfffc4284dcd457/pytz-2022.2.tar.gz"
    sha256 "bc824559e43e8ab983426a49525079d186b25372ff63aa3430ccd527d95edc3a"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/50/5c/d32aeed5c91e7970ee6ab8316c08d911c1d6044929408f6bbbcc763f8019/requests-file-1.5.1.tar.gz"
    sha256 "07d74208d3389d01c38ab89ef403af0cfec63957d53a0081d8eca738d0247d8e"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/28/30/7bf7e5071081f761766d46820e52f4b16c8a08fef02d2eb4682ca7534310/requests-toolbelt-0.9.1.tar.gz"
    sha256 "968089d4584ad4ad7c171454f0a5c6dac23971e9472521ea3b6d49d610aa6fc0"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a4/50/8e34f3f18dc3914bd14a0722cb471410488495fdcd93e122724d4dd8c5f9/rich-12.3.0.tar.gz"
    sha256 "7e8700cda776337036a712ff0495b04052fb5f957c7dfb8df997f88350044b64"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "SoftLayer" do
    url "https://files.pythonhosted.org/packages/c5/a0/c5968103a854052f2559f39e72a32dd4b90331b7de1c82e45c000ed5a839/SoftLayer-6.1.0.tar.gz"
    sha256 "e2d4563c97429cdd12ccd6316ceb9beb5ab0a184d2cb580d35bd5db01e8a6c89"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/f3/03/bac179d539362319b4779a00764e95f7542f4920084163db6b0fd4742d38/soupsieve-2.3.2.post1.tar.gz"
    sha256 "fc53893b3da2c33de295667a0e19f078c14bf86544af307354de5fcf12a3f30d"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/80/d8/75264c54cfa1371d2a42fb613c24d71628c411764ab0d5046b54ca18a5b2/tldextract-3.3.1.tar.gz"
    sha256 "fe15ac3205e5a25b61689369f98cb45c7778a8f2af113d7c11559ece5195f2d6"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/6d/d5/e8258b334c9eb8eb78e31be92ea0d5da83ddd9385dc967dd92737604d239/urllib3-1.26.11.tar.gz"
    sha256 "ea6e8fb210b19d950fab93b60c9009226c63a28808bc8386e05301e25883ac0a"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  resource "zeep" do
    url "https://files.pythonhosted.org/packages/f8/d2/9c40fc50fa8d8ac2a744403e3c5eb64548daa9783c6ca060f74f911c006d/zeep-4.1.0.tar.gz"
    sha256 "5867f2eadd6b028d9751f4155af590d3aaf9280e3a0ed5e15a53343921c956e5"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/3b/e3/fb79a1ea5f3a7e9745f688855d3c673f2ef7921639a380ec76f7d4d83a85/zipp-3.8.1.tar.gz"
    sha256 "05b45f1ee8f807d0cc928485ca40a07cb491cf092ff587c0df9cb1fd154848d2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/lexicon route53 list brew.sh TXT 2>&1", 1)
    assert_match "Unable to locate credentials", output

    output = shell_output("#{bin}/lexicon cloudflare create domain.net TXT --name foo --content bar 2>&1", 1)
    assert_match "400 Client Error: Bad Request for url", output

    assert_match "lexicon #{version}", shell_output("#{bin}/lexicon --version")
  end
end
