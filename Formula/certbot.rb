class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https://certbot.eff.org/"
  url "https://files.pythonhosted.org/packages/c7/b4/c690a764b762d0c5e2e757094d8b97b1db710fbcf38ae9db74e787f9a500/certbot-2.5.0.tar.gz"
  sha256 "76e6e5305021d3ee54c42fc471f8f0ed5dba790e6fd7fef6713060b0e42b97d7"
  license "Apache-2.0"
  head "https://github.com/certbot/certbot.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c0b065d4f6308ea6dca75da33615a75fd1f54fed4c361ba3f3fadd332fcabcc6"
    sha256 cellar: :any,                 arm64_monterey: "116496c0901b743114004e41d7cb491f130bd76a2433c9cb72b4829ef84bbe0a"
    sha256 cellar: :any,                 arm64_big_sur:  "e8c590318280e92632d77c3c27d9d837c7f8f2c883c0b734588fdd68c35eb859"
    sha256 cellar: :any,                 ventura:        "4850253f001f77b7d47903d22bacc5e66a9362b23138197a3bdefd995db72619"
    sha256 cellar: :any,                 monterey:       "20918faba0f8f7e6932b1562753302e3103a9428467398fd1debe3eeb43efe72"
    sha256 cellar: :any,                 big_sur:        "ec051aa0291b467bf358f36cbbb6c4894629b3428ba946df866e2e5398aa6b8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44044c07a044c21f05e20d6af1fee4aa95b41f04231a6991e6830fdd34528e9d"
  end

  # `pkg-config`, `rust`, and `openssl@1.1` are for cryptography.
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "augeas"
  depends_on "cffi"
  depends_on "dialog"
  depends_on "openssl@1.1"
  depends_on "pycparser"
  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "acme" do
    url "https://files.pythonhosted.org/packages/22/90/4de0868b48415b757ccc8afd9a51092123050d121b70bbfa0a0dbdb626d9/acme-2.5.0.tar.gz"
    sha256 "9c760b115c54f55f692321abe5d09f5c70ce437e61f9f22340341621d9909a5a"
  end

  resource "certbot-apache" do
    url "https://files.pythonhosted.org/packages/76/d6/278abc6c93c1594af92a403caea758a4718045a48a8927acadc77e0fb809/certbot-apache-2.5.0.tar.gz"
    sha256 "96c9cd62ed57c2307282d7203d07d378d929ce644d6ea0bee6d6cff72a85ac70"
  end

  resource "certbot-nginx" do
    url "https://files.pythonhosted.org/packages/1e/89/dbec566e2aedbdd77a10896be218f7d23d0eff130ea5d00b531d4d659077/certbot-nginx-2.5.0.tar.gz"
    sha256 "499fc15de782689a1dc2a224e8978e5de8369f6aef63262698ea2cc48e8028b5"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/16/05/385451bc8d20a3aa1d8934b32bd65847c100849ebba397dbf6c74566b237/ConfigArgParse-1.5.3.tar.gz"
    sha256 "1b0b3cbf664ab59dada57123c81eff3d9737e0d11d8cf79e3d6eb10823f1739f"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/15/d9/c679e9eda76bfc0d60c9d7a4084ca52d0631d9f24ef04f818012f6d1282e/cryptography-40.0.1.tar.gz"
    sha256 "2803f2f8b1e95f614419926c7e6f55d828afc614ca5ed61543877ae668cc3472"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/4b/89/eaa3a3587ebf8bed93e45aa79be8c2af77d50790d15b53f6dfc85b57f398/distro-1.8.0.tar.gz"
    sha256 "02e111d1dc6a50abb8eed6bf31c3e48ed8b0830d1ea2a1b78c61765c2513fdd8"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "josepy" do
    url "https://files.pythonhosted.org/packages/f4/be/5c1d9decbd5e9cf97dccd40d13c5657bef936d87da03c9d7aeb67c1b5126/josepy-1.13.0.tar.gz"
    sha256 "8931daf38f8a4c85274a0e8b7cb25addfd8d1f28f9fb8fbed053dd51aec75dc9"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/8f/72/f1d9e92f5d3a58aba3b71ad512de19eb9f82e7b98795662bf7b796be71e5/pyOpenSSL-23.1.1.tar.gz"
    sha256 "841498b9bec61623b1b6c47ebbc02367c07d60e0e195f19790817f10cc8db0b7"
  end

  # Required for tests
  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "pyRFC3339" do
    url "https://files.pythonhosted.org/packages/00/52/75ea0ae249ba885c9429e421b4f94bc154df68484847f1ac164287d978d7/pyRFC3339-1.1.tar.gz"
    sha256 "81b8cbe1519cdb79bed04910dd6fa4e181faf8c88dff1e1b987b5f7ab23a5b1a"
  end

  # Required for tests
  resource "python-augeas" do
    url "https://files.pythonhosted.org/packages/af/cc/5064a3c25721cd863e6982b87f10fdd91d8bcc62b6f7f36f5231f20d6376/python-augeas-1.1.0.tar.gz"
    sha256 "5194a49e86b40ffc57055f73d833f87e39dce6fce934683e7d0d5bbb8eff3b8c"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/5e/32/12032aa8c673ee16707a9b6cdda2b09c0089131f35af55d443b6a9c69c1d/pytz-2023.3.tar.gz"
    sha256 "1d8ce29db189191fb55338ee6d0387d82ab59f3d00eac103412d64e0ebd0c588"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    if build.head?
      head_packages = %w[acme certbot certbot-apache certbot-nginx]
      venv = virtualenv_create(libexec, "python3.11")
      venv.pip_install resources.reject { |r| head_packages.include? r.name }
      venv.pip_install_and_link head_packages.map { |pkg| buildpath/pkg }
      pkgshare.install buildpath/"certbot/examples"
    else
      virtualenv_install_with_resources
      pkgshare.install buildpath/"examples"
    end
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/certbot --version 2>&1")
    # This throws a bad exit code but we can check it actually is failing
    # for the right reasons by asserting. --version never fails even if
    # resources are missing or outdated/too new/etc.
    assert_match "Either run as root", shell_output("#{bin}/certbot 2>&1", 1)
  end
end
