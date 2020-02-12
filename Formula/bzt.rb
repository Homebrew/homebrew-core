class Bzt < Formula
  include Language::Python::Virtualenv

  desc "BlazeMeter Taurus"
  homepage "https://gettaurus.org/"
  url "https://files.pythonhosted.org/packages/source/b/bzt/bzt-1.14.1.tar.gz"
  sha256 "8314061bf70f0c2efedfcaf9aa61e2a5fc8ee7c71106a9658af7029fb9e79601"
  head "https://github.com/Blazemeter/taurus.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eaf6ade8377ff46a867b54063004537a89fa07656c8c544bd8db038be5c7f8a4" => :catalina
    sha256 "151a64d481625deb4a411f77413e0187b1e23969c17e009879447a1b29243eb6" => :mojave
    sha256 "6dfcde32c1a7f424070b1515c93d3824c929ac80f288a8ba17caf79c75dcbf72" => :high_sierra
  end

  depends_on "python@3.8"

  resource "apiritif" do
    url "https://files.pythonhosted.org/packages/2f/e0/642106c6e4100fac512f4d03cf4ed48b19d7f267dcb592f574aef634b36e/apiritif-0.9.1.tar.gz"
    sha256 "dc415e142401642de73fad3bfbe8c523aa08611c0f68af90bdb1be6de1213cf1"
  end

  resource "Appium-Python-Client" do
    url "https://files.pythonhosted.org/packages/ce/9d/2cf2934bc219d6dfd749fb1d4cbe2f01dcd32eaedd7c6f2bbed0ad2297a8/Appium-Python-Client-0.49.tar.gz"
    sha256 "97b479edd875a8942d5a47334bd621e9fda81fe5fd9886adfa28eab1caecf916"
  end

  resource "astunparse" do
    url "https://files.pythonhosted.org/packages/f3/af/4182184d3c338792894f34a62672919db7ca008c89abee9b564dd34d8029/astunparse-1.6.3.tar.gz"
    sha256 "5ad93a8456f0d084c3456d059fd9a92cce667963232cbf763eac3bc5b7940872"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/98/c3/2c227e66b5e896e15ccdae2e00bbc69aa46e9a8ce8869cc5fa96310bf612/attrs-19.3.0.tar.gz"
    sha256 "f7b7ce16570fe9965acd6d30101a28f62fb4a7f9e926b3bbc9b61f8b04247e72"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/41/bf/9d214a5af07debc6acf7f3f257265618f1db242a3f8e49a9b516f24523a6/certifi-2019.11.28.tar.gz"
    sha256 "25b64c7da4cd7479594d035c08c2d809eb4aab3a26e5a990ea98cc450c320f1f"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/a5/51/c6e1f2c7e6d7524b580d5a8d7691fd4530f894ae8a23ba66a065291ceba2/colorlog-4.1.0.tar.gz"
    sha256 "30aaef5ab2a1873dec5da38fd6ba568fa761c9fa10b40241027fa3edea47f3d2"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/70/54/37630f6eb2c214cdee2ae56b7287394c8aa2f3bafb8b4eb8c3791aae7a14/cssselect-1.1.0.tar.gz"
    sha256 "f95f8dedd925fd8f54edb3d2dfb44c190d9d18512377d3c1e2388d16126879bc"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/dc/c3/9d378af09f5737cfd524b844cd2fbb0d2263a35c11d712043daab290144d/decorator-4.4.1.tar.gz"
    sha256 "54c38050039232e1db4ad7375cfce6748d7b41c29e95a081c8a6d2c30364a2ce"
  end

  resource "EasyProcess" do
    url "https://files.pythonhosted.org/packages/30/2d/b8afe262637636f27ec45af5792585d756b8f55380e657d5681d265d41c6/EasyProcess-0.2.9.tar.gz"
    sha256 "ddb7a425bc68936fb2ca91fa5ab385da3b58cd10c9134fa26f5210be5dbf47c6"
  end

  resource "fuzzyset" do
    url "https://files.pythonhosted.org/packages/2e/78/7509f3efbb6acbcf842d7bdbd9a919ca8c0ed248123bdd8c57f08497e0dd/fuzzyset-0.0.19.tar.gz"
    sha256 "2bf5a3de20f107124a4842d875e5005ee523719f97ab731caf4121e86ec8ccbc"
  end

  resource "hdrpy" do
    url "https://files.pythonhosted.org/packages/47/8c/159be762f787888651f9895a60d8564d2c1df5b2581cc733823b45759cfd/hdrpy-0.3.3.tar.gz"
    sha256 "8461ed2c0d577468e5499f8b685d9bf9660b72b8640bff02c78ba1f1b9bf5185"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/8c/0e/10e247f40c89ba72b7f2a2104ccf1b65de18f79562ffe11bfb837b711acf/importlib_metadata-1.4.0.tar.gz"
    sha256 "f17c015735e1a88296994c0697ecea7e11db24290941983b08c9feb30921e6d8"
  end

  resource "jsonpath-rw" do
    url "https://files.pythonhosted.org/packages/71/7c/45001b1f19af8c4478489fbae4fc657b21c4c669d7a5a036a86882581d85/jsonpath-rw-1.4.0.tar.gz"
    sha256 "05c471281c45ae113f6103d1268ec7a4831a2e96aa80de45edc89b11fac4fbec"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e4/19/8dfeef50623892577dc05245093e090bb2bab4c8aed5cad5b03208959563/lxml-4.4.2.tar.gz"
    sha256 "eff69ddbf3ad86375c344339371168640951c302450c5d3e9936e98d6459db06"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/df/8c/c278395367a46c00d28036143fdc6583db8f98622b83875403f16473509b/more-itertools-8.1.0.tar.gz"
    sha256 "c468adec578380b6281a114cb8a5db34eb1116277da92d7c46f904f0b52d3288"
  end

  resource "nose" do
    url "https://files.pythonhosted.org/packages/58/a5/0dc93c3ec33f4e281849523a5a913fa1eea9a3068acfa754d44d88107a44/nose-1.3.7.tar.gz"
    sha256 "f1bffef9cbc82628f6e7d7b40d7e255aefaa1adb6a1b1d26c69a8b79e6208a98"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/40/de/0ea5092b8bfd2e3aa6fdbb2e499a9f9adf810992884d414defc1573dca3f/numpy-1.18.1.zip"
    sha256 "b6ff59cee96b454516e47e7721098e6ceebef435e3e21ac2d6c3b8b02628eb77"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7b/d5/199f982ae38231995276421377b72f4a25d8251f4fa56f6be7cfcd9bb022/packaging-20.1.tar.gz"
    sha256 "e665345f9eef0c621aa0bf2f8d78cf6d21904eef16a93f020240b704a57f1334"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f8/04/7a8542bed4b16a65c2714bf76cf5a0b026157da7f75e87cc88774aa10b14/pluggy-0.13.1.tar.gz"
    sha256 "15b2acde666561e1298d71b523007ed7364de07029219b604cf808bfa1c765b0"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "progressbar33" do
    url "https://files.pythonhosted.org/packages/71/fc/7c8e01f41a6e671d7b11be470eeb3d15339c75ce5559935f3f55890eec6b/progressbar33-2.4.tar.gz"
    sha256 "51fe0d9b3b4023db2f983eeccdfc8c9846b84db8443b9bee002c7f58f4376eff"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/73/93/4f8213fbe66fc20cb904f35e6e04e20b47b85bee39845cc66a0bcf5ccdcb/psutil-5.6.7.tar.gz"
    sha256 "ffad8eb2ac614518bbe3c0b8eb9dffdb3a8d2e3a7d5da51c5b974fb723a5c5aa"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/bd/8f/169d08dcac7d6e311333c96b63cbe92e7947778475e1a619b674989ba1ed/py-1.8.1.tar.gz"
    sha256 "5e27081401262157467ad6e7f851b7aa402c5852dbcb3dae06768434de5752aa"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/a2/56/0404c03c83cfcca229071d3c921d7d79ed385060bbe969fde3fd8f774ebd/pyparsing-2.4.6.tar.gz"
    sha256 "4c830582a84fb022400b85429791bc551f1f4871c33f23e44f353119e92f969f"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/eb/9c/8bf2a5e1a84e6b6d9a255ed1cda5d4b339699e9b1d95ed9f811209d588f8/pytest-5.3.4.tar.gz"
    sha256 "1d122e8be54d1a709e56f82e2d85dcba3018313d64647f38a91aec88c239b600"
  end

  resource "python-Levenshtein" do
    url "https://files.pythonhosted.org/packages/42/a9/d1785c85ebf9b7dfacd08938dd028209c34a0ea3b1bcdb895208bd40a67d/python-Levenshtein-0.12.0.tar.gz"
    sha256 "033a11de5e3d19ea25c9302d11224e1a1898fe5abd23c61c7c360c25195e3eb1"
  end

  resource "PyVirtualDisplay" do
    url "https://files.pythonhosted.org/packages/1e/7c/28b48481c8992727ac90526bb4395b76081b6df8265835a6d6a478c7e2c9/PyVirtualDisplay-0.2.5.tar.gz"
    sha256 "5b267c8ffc98fcbd084ba852ab4caef3f22e9362bc5d117e1697e767553eaf41"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/3d/d9/ea9816aea31beeadccd03f1f8b625ecf8f645bd66744484d162d84803ce5/PyYAML-5.3.tar.gz"
    sha256 "e9f45bd5b92c7974e59bcd2dcc8631a6b6cc380a904725fce7bc08872e691615"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/01/62/ddcf76d1d19885e8579acb1b1df26a852b03472c0e46d2b959a714c90608/requests-2.22.0.tar.gz"
    sha256 "11e007a8a2aa0323f5a921e9e6a2d7e4e67d9877e85773fba9ba6419025cbeb4"
  end

  resource "selenium" do
    url "https://files.pythonhosted.org/packages/ed/9c/9030520bf6ff0b4c98988448a93c04fcbd5b13cd9520074d8ed53569ccfe/selenium-3.141.0.tar.gz"
    sha256 "deaf32b60ad91a4611b98d8002757f29e6f2c2d5fcaf202e1c9ad06d6772300d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  resource "terminaltables" do
    url "https://files.pythonhosted.org/packages/9b/c4/4a21174f32f8a7e1104798c445dacdc1d4df86f2f26722767034e4de4bff/terminaltables-3.1.0.tar.gz"
    sha256 "f3eb0eb92e3833972ac36796293ca0906e998dc3be91fbe1f8615b331b853b81"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/82/a8/60df592e3a100a1f83928795aca210414d72cebdc6e4e0c95a6d8ac632fe/texttable-1.6.2.tar.gz"
    sha256 "eff3703781fbc7750125f50e10f001195174f13825a92a45e9403037d539b4f4"
  end

  resource "unicodecsv" do
    url "https://files.pythonhosted.org/packages/6f/a4/691ab63b17505a26096608cc309960b5a6bdf39e4ba1a793d5f9b1a53270/unicodecsv-0.14.1.tar.gz"
    sha256 "018c08037d48649a0412063ff4eda26eaa81eff1546dbffa51fa5293276ff7fc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/09/06/3bc5b100fe7e878d3dee8f807a4febff1a40c213d2783e3246edde1f3419/urllib3-1.25.8.tar.gz"
    sha256 "87716c2d2a7121198ebcb7ce7cccf6ce5e9ba539041cfbaeecfb641dc0bf6acc"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/c7/90/415728875c230fafd13d118512bde3184d810d7bf798a631abc05fac09d0/urwid-2.0.1.tar.gz"
    sha256 "644d3e3900867161a2fc9287a9762753d66bd194754679adb26aede559bcccbc"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/33/92333eb80be0c96385dee338f30b53e24a8b415d5785e225d789b3f90feb/wcwidth-0.1.8.tar.gz"
    sha256 "f28b3e8a6483e5d49e7f8949ac1a78314e740333ae305b4ba5defd3e74fb37a8"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/59/b0/11710a598e1e148fb7cbf9220fd2a0b82c98e94efbdecb299cb25e7f0b39/wheel-0.33.6.tar.gz"
    sha256 "10c9da68765315ed98850f8e048347c3eb06dd81822dc2ab1d4fde9dc9702646"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/60/85/668bca4a9ef474ca634c993e768f12bd99af1f06bb90bb2655bc538a967e/zipp-2.2.0.tar.gz"
    sha256 "5c56e330306215cd3553342cfafc73dda2c60792384117893f3a83f8a1209f50"
  end

  def install
    # Fix "ld: file not found: /usr/lib/system/libsystem_darwin.dylib" for lxml
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    virtualenv_install_with_resources
  end

  test do
    cmd = "#{bin}/bzt -o execution.executor=nose -o execution.iterations=1 -o execution.scenario.requests.0=https://gettaurus.org/"
    assert_match /INFO: Samples count: 1, .*% failures/, shell_output(cmd)
  end
end
