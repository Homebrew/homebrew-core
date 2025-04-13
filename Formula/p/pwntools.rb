class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://github.com/Gallopsled/pwntools"
  url "https://files.pythonhosted.org/packages/21/94/1f39d5a770226b9d240c9900c5c912788fb31f8f189aacd81153c0d59f67/pwntools-4.14.1.tar.gz"
  sha256 "60f04976d1722120d18b9d50553408a024664b5cf888f36f258afca4bf035cac"
  license "MIT"
  head "https://github.com/Gallopsled/pwntools.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8aeabb1da2e073cf98271f5aa6a77bb53f87bd9f6836e87447034d393cc7d443"
    sha256 cellar: :any,                 arm64_sonoma:  "bc82947f0006968034657b332a60d3be80385ddd7eb6938fd521b991166ad308"
    sha256 cellar: :any,                 arm64_ventura: "9238f6ca15b8daaad7b7dbc9c45a0edb8491a76bfba181ee972ff865b174dc21"
    sha256 cellar: :any,                 sonoma:        "a76835ebbd1f3cfbdab68b4d817a0f6e2f46ac93cff1cb5157d1d2ba1c74acb9"
    sha256 cellar: :any,                 ventura:       "f4964b88b6888cbc13b888e4526bfb7f70a97ce0d7461b4ff1ce5acd166e68c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4e1fbf0fcf71e6138c8f49f16cbd4d7d9784a4d91609dd73a5d2b6c016da0aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "932c911b364f5c269486b75ed63bb5a635de5ea626a868f89a2c480134ed3a8c"
  end

  depends_on "rust" => :build # for bcrypt
  depends_on "capstone"
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libsodium" # for pynacl
  depends_on "python@3.13"
  depends_on "unicorn" # for unicorn resource

  uses_from_macos "libffi"

  conflicts_with "moreutils", because: "both install an `errno` executable"
  conflicts_with "cspice", because: "both install `version` binaries"
  conflicts_with "jena", because: "both install `update` binaries"
  conflicts_with "scala", because: "both install `common` binaries"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/bb/5d/6d7433e0f3cd46ce0b43cd65e1db465ea024dbb8216fb2404e919c2ad77b/bcrypt-4.3.0.tar.gz"
    sha256 "3a3fd2204178b6d2adcf09cb4f6426ffef54762577a7c9b54c159008cb288c18"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "colored-traceback" do
    url "https://files.pythonhosted.org/packages/07/80/afcf567031ab8565f8f8d2bd14b007d313ea3258e50394e85b10a405099c/colored-traceback-0.4.2.tar.gz"
    sha256 "ecbc8e41f0712ea81931d7cd436b8beb9f3eff1595d2498f183e0ef69b56fe84"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "intervaltree" do
    url "https://files.pythonhosted.org/packages/50/fb/396d568039d21344639db96d940d40eb62befe704ef849b27949ded5c3bb/intervaltree-3.1.0.tar.gz"
    sha256 "902b1b88936918f9b2a19e0e5eb7ccb430ae45cde4f39ea4b36932920d33952d"
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/62/4f/ddb1965901bc388958db9f0c991255b2c469349a741ae8c9cd8a562d70a6/mako-1.3.9.tar.gz"
    sha256 "b5d65ff3462870feec922dbccf38f6efb44e5714d7b593a656be86663d8600ac"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/7d/15/ad6ce226e8138315f2451c2aeea985bf35ee910afb477bae7477dc3a8f3b/paramiko-3.5.1.tar.gz"
    sha256 "b2c665bc45b2b215bd7d7f039901b14b067da00f3a11e6640995fd58f2664822"
  end

  resource "plumbum" do
    url "https://files.pythonhosted.org/packages/f0/5d/49ba324ad4ae5b1a4caefafbce7a1648540129344481f2ed4ef6bb68d451/plumbum-1.9.0.tar.gz"
    sha256 "e640062b72642c3873bd5bdc3effed75ba4d3c70ef6b6a7b907357a84d909219"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/b9/ab/33968940b2deb3d92f5b146bc6d4009a5f95d1d06c148ea2f9ee965071af/pyelftools-0.32.tar.gz"
    sha256 "6de90ee7b8263e740c8715a925382d4099b354f29ac48ea40d840cf7aa14ace5"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "ropgadget" do
    url "https://files.pythonhosted.org/packages/b5/ad/7c6c9078c143d5cb7965f2d06a3aadc5f9e638276dd86e57ce8c9a30457c/ropgadget-7.6.tar.gz"
    sha256 "8883c54e4627073a2ce7cd8adbaf7ef72478442c0a5da1308c3c2e37641174c3"
  end

  resource "rpyc" do
    url "https://files.pythonhosted.org/packages/3a/9d/a48fb1246a4b431951947f7cc2b4a24ffe59c0ec4eec1396d275bc6a45ed/rpyc-6.0.1.tar.gz"
    sha256 "8a60f3c4401f309c0eb6e754fb6c4e0442231203907cebf61ae74615b52cd38a"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "unicorn" do
    url "https://files.pythonhosted.org/packages/90/12/a10f01a3e1dafcd21e2eb0c0d99bb51d5bda1d3fee20047cb2a4b2de6285/unicorn-2.1.2.tar.gz"
    sha256 "e4a9d671bdea71806f29a396734cfb83317f82943b52d0001d3bca1dcbaee893"
  end

  resource "unix-ar" do
    url "https://files.pythonhosted.org/packages/3e/37/65cb206bd7110887248fe041e00e61124abdcd23de8f19418898a51363fc/unix_ar-0.2.1.tar.gz"
    sha256 "bf9328ec70fa3a82f94dc26dc125264dbf62a2d8ffb1a3c8c8a8230175e72c4e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/ed/f6/2ac0287b442160a89d726b17a9184a4c615bb5237db763791a7fd16d9df1/zstandard-0.23.0.tar.gz"
    sha256 "b2d8c62d08e7255f68f7a740bae85b3c9b8e5466baa9cbf7f57f1cde0ac6bc09"
  end

  def install
    ENV["LIBUNICORN_PATH"] = Formula["unicorn"].opt_lib
    ENV["SODIUM_INSTALL"] = "system"
    venv = virtualenv_install_with_resources

    # Use shared library from `unicorn` formula. The is mainly required if
    # `unicorn` is unlinked as fallback load can find lib from linked path
    pyunicorn_lib = venv.site_packages/"unicorn/lib"
    pyunicorn_lib.mkpath
    Formula["unicorn"].opt_lib.glob(shared_library("libunicorn", "*")).each do |libunicorn|
      ln_s libunicorn.relative_path_from(pyunicorn_lib), pyunicorn_lib
    end

    bash_completion.install "extra/bash_completion.d/pwn"
    zsh_completion.install "extra/zsh_completion/_pwn"
  end

  test do
    assert_equal "686f6d6562726577696e7374616c6c636f6d706c657465",
                 shell_output("#{bin}/hex homebrewinstallcomplete").strip

    # Test that unicorn shared library can be loaded
    system libexec/"bin/python", "-c", "import unicorn.unicorn"
  end
end
