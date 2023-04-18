class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://github.com/Gallopsled/pwntools"
  url "https://files.pythonhosted.org/packages/6d/df/8d94f7c63ef35fdd1b2ee2ac1c54b308754a7e532af2a36b0cb77bd03542/pwntools-4.9.0.tar.gz"
  sha256 "eea67d182f9170488392998d9b2f1debb75889380505501f07707645fac7e712"
  license "MIT"
  head "https://github.com/Gallopsled/pwntools.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "7def60d9372945970c3258a09ea3cccaa4e72ff487e6c5e2b8315efe9eb19c38"
    sha256 cellar: :any,                 arm64_monterey: "7da5d023d77a4a624788e7760cae7413b87217f073e59e77e7a984b5167d6f41"
    sha256 cellar: :any,                 arm64_big_sur:  "b159dba200af451e828251897b3c76149b1b0a6eb3da55c9ace4df8d505d2bad"
    sha256 cellar: :any,                 ventura:        "4290fa8395c9ee818cf2fd04bc9999bf4da600a34ce7f7512430be3d22d1dc74"
    sha256 cellar: :any,                 monterey:       "670b28d401daa53741af43300db4bae97d47bca7e03d94c4c8dc44d37df30561"
    sha256 cellar: :any,                 big_sur:        "e6fe5d9df6e8777497efc527951d23e5a585295637f9883c1e859a8c3386430e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b8adf8413c27077c36a5442ca096adbaeba3e885a372b38fc2dfd81d854b234"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"
  depends_on "pygments"
  depends_on "python@3.11"
  depends_on "six"
  depends_on "unicorn"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  conflicts_with "moreutils", because: "both install an `errno` executable"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/8c/ae/3af7d006aacf513975fd1948a6b4d6f8b4a307f8a244e1a3d3774b297aad/bcrypt-4.0.1.tar.gz"
    sha256 "27d375903ac8261cfe4047f6709d16f7d18d39b1ec92aaf72af989552a650ebd"
  end

  resource "capstone" do
    url "https://files.pythonhosted.org/packages/0d/25/3496d5e23573bce9c1b753c215b80615e7b557680fcf4f1f804ac7defc97/capstone-5.0.0.tar.gz"
    sha256 "6e18ee140463881c627b7ff7fd655752ddf37d9036295d3dba7b130408fbabaf"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/96/d7/1675d9089a1f4677df5eb29c3f8b064aa1e70c1251a0a8a127803158942d/charset-normalizer-3.0.1.tar.gz"
    sha256 "ebea339af930f8ca5d7a699b921106c6e29c617fe9606fa7baa043c1cdae326f"
  end

  resource "colored-traceback" do
    url "https://files.pythonhosted.org/packages/9a/8b/0a4e2a8cdc14279b265532f11c9cb75396880e6295c99a0bed7281b6076a/colored-traceback-0.3.0.tar.gz"
    sha256 "6da7ce2b1da869f6bb54c927b415b95727c4bb6d9a84c4615ea77d9872911b05"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/6a/f5/a729774d087e50fffd1438b3877a91e9281294f985bda0fd15bf99016c78/cryptography-39.0.1.tar.gz"
    sha256 "d1f6198ee6d9148405e49887803907fe8962a23e6c6f83ea7d98f1c0de375695"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "intervaltree" do
    url "https://files.pythonhosted.org/packages/50/fb/396d568039d21344639db96d940d40eb62befe704ef849b27949ded5c3bb/intervaltree-3.1.0.tar.gz"
    sha256 "902b1b88936918f9b2a19e0e5eb7ccb430ae45cde4f39ea4b36932920d33952d"
  end

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/05/5f/2ba6e026d33a0e6ddc1dddf9958677f76f5f80c236bd65309d280b166d3e/Mako-1.2.4.tar.gz"
    sha256 "d60a3903dc3bb01a18ad6a89cdbe2e4eadc69c0bc8ef1e3773ba53d44c3f7a34"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/95/7e/68018b70268fb4a2a605e2be44ab7b4dd7ce7808adae6c5ef32e34f4b55a/MarkupSafe-2.1.2.tar.gz"
    sha256 "abcabc8c2b26036d62d4c746381a6f7cf60aafcc653198ad678306986b09450d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/3b/6b/554c00e5e68cd573bda345322a4e895e22686e94c7fa51848cd0e0442a71/paramiko-3.0.0.tar.gz"
    sha256 "fedc9b1dd43bc1d45f67f1ceca10bc336605427a46dcdf8dec6bfea3edf57965"
  end

  resource "plumbum" do
    url "https://files.pythonhosted.org/packages/56/e0/bcff74e68f8b71f4b9ce9e79b533df6d1ecff33c856fb93aab7e8a7c8d82/plumbum-1.8.1.tar.gz"
    sha256 "88a40fc69247d0cd585e21ca169b3820f46c484535102e16455d2202727bb37b"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/3d/7d/d05864a69e452f003c0d77e728e155a89a2a26b09e64860ddd70ad64fb26/psutil-5.9.4.tar.gz"
    sha256 "3d7f9739eb435d4b1338944abe23f49584bde5395f27487d2ee25ad9a8774a62"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/0e/35/e76da824595452a5ad07f289ea1737ca0971fc6cc7b6ee9464279be06b5e/pyelftools-0.29.tar.gz"
    sha256 "ec761596aafa16e282a31de188737e5485552469ac63b60cfcccf22263fd24ff"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "ROPGadget" do
    url "https://files.pythonhosted.org/packages/80/cc/476fd64384b2e238b984e13be09a068f2ff61917e53267c3274a3574c309/ROPGadget-7.2.tar.gz"
    sha256 "ec705810d37043b2aca32a164416c6198de7770bb5e45ca1bc219acb87ee2073"
  end

  resource "rpyc" do
    url "https://files.pythonhosted.org/packages/36/56/3063981236a19c2a99a41f8184e7b34d4920668af74abe6b715e433f4a43/rpyc-5.3.0.tar.gz"
    sha256 "cde4bd871c9008d16312ce7f432d4d50a38ddc300115045f1bbd78ba14651404"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "unicorn" do
    url "https://files.pythonhosted.org/packages/64/c7/1a571a06adda2a9802e21d84398c5547761cb28b22f59a2c5db62bf23887/unicorn-2.0.1.post1.tar.gz"
    sha256 "7fc69523eb83b4c8abc7cb4410ca21875e066c34b7afe998f59481e830d28e56"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  def install
    ENV["LIBUNICORN_PATH"] = Formula["unicorn"].opt_lib
    virtualenv_install_with_resources
    bin.each_child do |f|
      f.unlink
      # Use env scripts to help unicorn python bindings dynamically load shared library
      f.write_env_script libexec/"bin"/f.basename, LIBUNICORN_PATH: Formula["unicorn"].opt_lib
    end
    bash_completion.install "extra/bash_completion.d/pwn"
    zsh_completion.install "extra/zsh_completion/_pwn"
  end

  test do
    assert_equal "686f6d6562726577696e7374616c6c636f6d706c657465",
                 shell_output("#{bin}/hex homebrewinstallcomplete").strip
  end
end
