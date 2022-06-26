class Bzt < Formula
  include Language::Python::Virtualenv

  desc "BlazeMeter Taurus"
  homepage "https://gettaurus.org/"
  url "https://files.pythonhosted.org/packages/2d/cd/69d864c9d306f767751648edb3cebe2c8532913f8c4be74cc2223ffda5bf/bzt-1.16.3.tar.gz"
  sha256 "effb95393b67ae95f26a1bd1d927a76b7e66abf118a4f0c099f489373a8bc004"
  license "Apache-2.0"
  revision 1
  head "https://github.com/Blazemeter/taurus.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f831ff866dfd40136b02c2736feb5c5d894c9efa96235bd7315c422ebe0b6e76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0b8234395c6ddbdc7d6401a59ecd57806daf4c7440c6f33057b62fe04ca5b85"
    sha256 cellar: :any_skip_relocation, monterey:       "af2143eefb306cc068662bc0b28a742f814295c481a2e1e87d5230ea9bd37650"
    sha256 cellar: :any_skip_relocation, big_sur:        "45024a8026b3be9f72e0651c0b5841ada3e8c1e05d2b549f116a6af4b38da714"
    sha256 cellar: :any_skip_relocation, catalina:       "22e3985d7dad57b9f7c4713b54bc46ff3cb0ffe9d46c37b3e07db7d78106ed0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e41f7882fdb50307a1efb61947a7c7c56388704bf44ed2706eb6d2059548ba3a"
  end

  depends_on "rust" => :build
  depends_on "numpy"
  depends_on "python@3.10"
  depends_on "six"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  # Needs setuptools < 60.0.0
  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/ef/75/2bc7bef4d668f9caa9c6ed3f3187989922765403198243040d08d2a52725/setuptools-59.8.0.tar.gz"
    sha256 "09980778aa734c3037a47997f28d6db5ab18bdf2af0e49f719bfc53967fd2e82"
  end

  resource "aiodogstatsd" do
    url "https://files.pythonhosted.org/packages/8d/ea/d2d79661f213f09df0e9f56d25dbae41501880822e5c85a0a6d6857baa55/aiodogstatsd-0.16.0.post0.tar.gz"
    sha256 "f783c7d6d74edd160b34141ff5f069c9a935bb32636823e39e36f0d1dbe14931"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/5a/86/5f63de7a202550269a617a5d57859a2961f3396ecd1739a70b92224766bc/aiohttp-3.8.1.tar.gz"
    sha256 "fc5471e1a54de15ef71c1bc6ebe80d4dc681ea600e68bfd1cbce40427f0b7578"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/27/6b/a89fbcfae70cf53f066ec22591938296889d3cc58fec1e1c393b10e8d71d/aiosignal-1.2.0.tar.gz"
    sha256 "78ed67db6c7b7ced4f98e495e572106d5c432a93e1ddd1bf475e1dc05f5b7df2"
  end

  resource "astunparse" do
    url "https://files.pythonhosted.org/packages/f3/af/4182184d3c338792894f34a62672919db7ca008c89abee9b564dd34d8029/astunparse-1.6.3.tar.gz"
    sha256 "5ad93a8456f0d084c3456d059fd9a92cce667963232cbf763eac3bc5b7940872"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/54/6e/9678f7b2993537452710ffb1750c62d2c26df438aa621ad5fa9d1507a43a/async-timeout-4.0.2.tar.gz"
    sha256 "2163e1640ddb52b7a8c80d0a67a08587e5d245cc9c553a74a847056bc2976b15"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/d7/77/ebb15fc26d0f815839ecd897b919ed6d85c050feeb83e100e020df9153d2/attrs-21.4.0.tar.gz"
    sha256 "626ba8234211db98e869df76230a137c4c40a12d72445c45d5f5b716f076e2fd"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/48/44/76b179e0d1afe6e6a91fd5661c284f60238987f3b42b676d141d01cd5b97/charset-normalizer-2.0.10.tar.gz"
    sha256 "876d180e9d7432c5d1dfd4c5d26b72f099d503e8fcc0feb7532c9289be60fcbd"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/8e/8f/1537ebed273d43edd3bb21f1e5861549b7cfcb1d47523d7277cab988cec2/colorlog-6.6.0.tar.gz"
    sha256 "344f73204009e4c83c5b6beb00b3c45dc70fcdae3c80db919e0a4171d006fde8"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/70/54/37630f6eb2c214cdee2ae56b7287394c8aa2f3bafb8b4eb8c3791aae7a14/cssselect-1.1.0.tar.gz"
    sha256 "f95f8dedd925fd8f54edb3d2dfb44c190d9d18512377d3c1e2388d16126879bc"
  end

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/bc/fa/8604d92ef753e0036d807f1b3179813ab2fa283e3b19c926e11673c8205b/Cython-0.29.26.tar.gz"
    sha256 "af377d543a762867da11fcf6e558f7a4a535ff8693f30cce123fab10c00fa312"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/57/b7/c4aa04a27040e6a3b09f5a652976ead00b66504c014425a7aad887aa8d7f/dill-0.3.4.zip"
    sha256 "9f9734205146b2b353ab3fec9af0070237b6ddae78452af83d2fca84d739e675"
  end

  resource "EasyProcess" do
    url "https://files.pythonhosted.org/packages/86/e5/1071ad7de469bf3baae5b04d6c8019876c819c2d428cc1b0f15b4b31fc89/EasyProcess-1.1.tar.gz"
    sha256 "885898302a57aab948973e8b5d32a4229392b9fb2d986ab1d4ffd590e5ba90ec"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/f4/f7/8dfeb76d2a52bcea2b0718427af954ffec98be1d34cd8f282034b3e36829/frozenlist-1.3.0.tar.gz"
    sha256 "ce6f2ba0edb7b0c1d8976565298ad2deba6f8064d2bebb6ffce2ca896eb35b0b"
  end

  resource "fuzzyset2" do
    url "https://files.pythonhosted.org/packages/0f/87/a274c7bd22b39dc878b3e54f601b491631c4d4bf13b0c9bda72a5015cd4a/fuzzyset2-0.2.0.tar.gz"
    sha256 "009de9edbe2dc7b7c88a0d905d59bbcb1354c319d9cad01482d9dc929b4e226d"
  end

  resource "hdrpy" do
    url "https://files.pythonhosted.org/packages/47/8c/159be762f787888651f9895a60d8564d2c1df5b2581cc733823b45759cfd/hdrpy-0.3.3.tar.gz"
    sha256 "8461ed2c0d577468e5499f8b685d9bf9660b72b8640bff02c78ba1f1b9bf5185"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/84/74/4a97db45381316cd6e7d4b1eb707d7f60d38cb2985b5dfd7251a340404da/lxml-4.7.1.tar.gz"
    sha256 "a1613838aa6b89af4ba10a0f3a972836128801ed008078f8c1244e65958f1b24"
  end

  resource "molotov" do
    url "https://files.pythonhosted.org/packages/9d/19/18fabf965da6050e619c11e6338d09cf6a90f953ae28fb7af9513322127b/molotov-2.4.tar.gz"
    sha256 "2caaf45b4bb2a67f3463466e9ee807b67b1a1aae28de54b8dcd1c47feee69336"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/fa/a7/71c253cdb8a1528802bac7503bf82fe674367e4055b09c28846fdfa4ab90/multidict-6.0.2.tar.gz"
    sha256 "5ff3bd75f38e4c43f1f470f2df7a4d430b821c4ce22be384e1459cb57d6bb013"
  end

  resource "multiprocessing_on_dill" do
    url "https://files.pythonhosted.org/packages/86/4d/4b135e2e5cd0194eb29f2ed36e9a77a07596787a9a8ac2279bd4445398f2/multiprocessing_on_dill-3.5.0a4.tar.gz"
    sha256 "d6d50c300ff4bd408bb71eb78725e60231039ee9b3d0d9bb7697b9d0e15045e7"
  end

  resource "progressbar33" do
    url "https://files.pythonhosted.org/packages/71/fc/7c8e01f41a6e671d7b11be470eeb3d15339c75ce5559935f3f55890eec6b/progressbar33-2.4.tar.gz"
    sha256 "51fe0d9b3b4023db2f983eeccdfc8c9846b84db8443b9bee002c7f58f4376eff"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/47/b6/ea8a7728f096a597f0032564e8013b705aa992a0990becd773dcc4d7b4a7/psutil-5.9.0.tar.gz"
    sha256 "869842dbd66bb80c3217158e629d6fceaecc3a3166d3d1faee515b05dd26ca25"
  end

  resource "PyVirtualDisplay" do
    url "https://files.pythonhosted.org/packages/2f/3d/d0edda70805ac705b09bc0183fb596f0323b0833399dae1799f7d7e251f4/PyVirtualDisplay-2.2.tar.gz"
    sha256 "3ecda6b183b03ba65dcfdf0019809722480d7b7e10eea6e3a40bf1ba3146bab7"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "rapidfuzz" do
    url "https://files.pythonhosted.org/packages/7f/51/e00e3b8e5fc0be5a3f5c320bbd75c9aead4b958221103a81471f847ca9b2/rapidfuzz-1.9.1.tar.gz"
    sha256 "bd7a4fe33ba49db3417f0f57a8af02462554f1296dedcf35b026cd3525efef74"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "terminaltables" do
    url "https://files.pythonhosted.org/packages/f5/fc/0b73d782f5ab7feba8d007573a3773c58255f223c5940a7b7085f02153c3/terminaltables-3.1.10.tar.gz"
    sha256 "ba6eca5cb5ba02bba4c9f4f985af80c54ec3dccf94cfcd190154386255e47543"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b0/b1/7bbf5181f8e3258efae31702f5eab87d8a74a72a0aa78bc8c08c1466e243/urllib3-1.26.8.tar.gz"
    sha256 "0e7c33d9a63e7ddfcb86780aac87befc2fbddf46c58dbb487e0855f7ceec283c"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/94/3f/e3010f4a11c08a5690540f7ebd0b0d251cc8a456895b7e49be201f73540c/urwid-2.1.2.tar.gz"
    sha256 "588bee9c1cb208d0906a9f73c613d2bd32c3ed3702012f51efe318a3f2127eae"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/c0/6c/9f840c2e55b67b90745af06a540964b73589256cb10cc10057c87ac78fc2/wheel-0.37.1.tar.gz"
    sha256 "e9a504e793efbca1b8e0e9cb979a249cf4a0a7b5b8c9e8b65a5e39d49529c1c4"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/f6/da/46d1b3d69a9a0835dabf9d59c7eb0f1600599edd421a4c5a15ab09f527e0/yarl-1.7.2.tar.gz"
    sha256 "45399b46d60c253327a460e99856752009fcee5f5d3c80b2f7c0cae1c38d56dd"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    cmd = "#{bin}/bzt -v -o execution.executor=locust -o execution.iterations=1 -o execution.scenario.requests.0=https://gettaurus.org/"
    # assert_match /INFO: Samples count: 1, .*% failures/, shell_output(cmd)
    system(cmd)
  end
end
