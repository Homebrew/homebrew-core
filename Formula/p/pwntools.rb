class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://github.com/Gallopsled/pwntools"
  url "https://files.pythonhosted.org/packages/f2/5c/9ae3d94c98b0b038ffd7f09ebdac506d346fe1b964999f71c96c8a904efd/pwntools-4.15.0.tar.gz"
  sha256 "d99a917298c1ca7241b51bba9ad2212f2af441ef66488059b2426508e9a2a776"
  license "MIT"
  head "https://github.com/Gallopsled/pwntools.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "4c355eda7c35221bc892f10b1ee92f1b7f91ce1ed8170f22fc8c05216ffc5710"
    sha256 cellar: :any,                 arm64_sequoia: "b55c6551ef56de78b535e116434f699d1690918bd6085a42221cbd135968c561"
    sha256 cellar: :any,                 arm64_sonoma:  "b11119452f91e64a62dce1eb574b64466629381d13c36914cd0c8a659095f28c"
    sha256 cellar: :any,                 sonoma:        "541ed20ad304e85dde99114cff63f2c0ac2b313e2b09a254f5f3496a8022161a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7991431d3e5e52fc0e38a04d55a08bbc80b2bed541b320522e4d3fe44d74baf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f55b7d5850811f509a03834f25d042123337192d06cc1611299c88098662acc"
  end

  depends_on "rust" => :build # for bcrypt
  depends_on "capstone"
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libsodium" # for pynacl
  depends_on "python@3.14"
  depends_on "unicorn" => :no_linkage # for unicorn resource

  uses_from_macos "libffi"

  conflicts_with "moreutils", because: "both install an `errno` executable"
  conflicts_with "cspice", because: "both install `version` binaries"
  conflicts_with "jena", because: "both install `update` binaries"
  conflicts_with "scala", because: "both install `common` binaries"

  pypi_packages exclude_packages: %w[capstone certifi cryptography]

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d4/36/3329e2518d70ad8e2e5817d5a4cac6bba05a47767ec416c7d020a965f408/bcrypt-5.0.0.tar.gz"
    sha256 "f748f7c2d6fd375cc93d3fba7ef4a9e3a092421b8dbf34d8d4dc06be9492dfdd"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "colored-traceback" do
    url "https://files.pythonhosted.org/packages/07/80/afcf567031ab8565f8f8d2bd14b007d313ea3258e50394e85b10a405099c/colored-traceback-0.4.2.tar.gz"
    sha256 "ecbc8e41f0712ea81931d7cd436b8beb9f3eff1595d2498f183e0ef69b56fe84"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "intervaltree" do
    url "https://files.pythonhosted.org/packages/50/fb/396d568039d21344639db96d940d40eb62befe704ef849b27949ded5c3bb/intervaltree-3.1.0.tar.gz"
    sha256 "902b1b88936918f9b2a19e0e5eb7ccb430ae45cde4f39ea4b36932920d33952d"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/de/bd/b461d3424a24c80490313fd77feeb666ca4f6a28c7e72713e3d9095719b4/invoke-2.2.1.tar.gz"
    sha256 "515bf49b4a48932b79b024590348da22f39c4942dff991ad1fb8b8baea1be707"
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/9e/38/bd5b78a920a64d708fe6bc8e0a2c075e1389d53bef8413725c63ba041535/mako-1.3.10.tar.gz"
    sha256 "99579a6f39583fa7e5630a28c3c1f440e4e97a414b80372649c0ce338da2ea28"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/1f/e7/81fdcbc7f190cdb058cffc9431587eb289833bdd633e2002455ca9bb13d4/paramiko-4.0.0.tar.gz"
    sha256 "6a25f07b380cc9c9a88d2b920ad37167ac4667f8d9886ccebd8f90f654b5d69f"
  end

  resource "plumbum" do
    url "https://files.pythonhosted.org/packages/f0/5d/49ba324ad4ae5b1a4caefafbce7a1648540129344481f2ed4ef6bb68d451/plumbum-1.9.0.tar.gz"
    sha256 "e640062b72642c3873bd5bdc3effed75ba4d3c70ef6b6a7b907357a84d909219"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/b3/31/4723d756b59344b643542936e37a31d1d3204bcdc42a7daa8ee9eb06fb50/psutil-7.1.0.tar.gz"
    sha256 "655708b3c069387c8b77b072fc429a57d0e214221d01c0a772df7dfedcb3bcd2"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/b9/ab/33968940b2deb3d92f5b146bc6d4009a5f95d1d06c148ea2f9ee965071af/pyelftools-0.32.tar.gz"
    sha256 "6de90ee7b8263e740c8715a925382d4099b354f29ac48ea40d840cf7aa14ace5"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/06/c6/a3124dee667a423f2c637cfd262a54d67d8ccf3e160f3c50f622a85b7723/pynacl-1.6.0.tar.gz"
    sha256 "cb36deafe6e2bce3b286e5d1f3e1c246e0ccdb8808ddb4550bb2792f2df298f2"
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
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "ropgadget" do
    url "https://files.pythonhosted.org/packages/b5/ad/7c6c9078c143d5cb7965f2d06a3aadc5f9e638276dd86e57ce8c9a30457c/ropgadget-7.6.tar.gz"
    sha256 "8883c54e4627073a2ce7cd8adbaf7ef72478442c0a5da1308c3c2e37641174c3"
  end

  resource "rpyc" do
    url "https://files.pythonhosted.org/packages/8b/e7/1c17410673b634f4658bb5d2232d0c4507432a97508b2c6708e59481644a/rpyc-6.0.2.tar.gz"
    sha256 "8e780a6a71b842128a80a337c64adfb6f919014e069951832161c9efc630c93b"
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
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/fd/aa/3e0508d5a5dd96529cdc5a97011299056e14c6505b678fd58938792794b1/zstandard-0.25.0.tar.gz"
    sha256 "7713e1179d162cf5c7906da876ec2ccb9c3a9dcbdffef0cc7f70c3667a205f0b"
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
