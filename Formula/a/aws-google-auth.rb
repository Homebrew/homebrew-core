class AwsGoogleAuth < Formula
  include Language::Python::Virtualenv

  desc "Acquire AWS credentials using Google Apps"
  homepage "https://github.com/cevoaustralia/aws-google-auth"
  url "https://files.pythonhosted.org/packages/32/4c/3a1dd1781c9d3bb4a85921b3d3e6e32fc0f0bad61ace6a8e1bd1a59c5ba0/aws-google-auth-0.0.38.tar.gz"
  sha256 "7a044636df2f0ce6ceb01f8f57aba0b6a79ae58a91bef788b0ccc6474914e8ee"
  license "MIT"
  revision 5
  head "https://github.com/cevoaustralia/aws-google-auth.git", branch: "master"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c538cefd9f61ae58f76b218e8579fb408a358d6ccffbbb3daaabf19f14fd1eab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5df9e454fd2b948ccd336397849d8aa6d68ec8e921847f085799dbe0620294cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26e1b87ee7ce3587a4688209c7f6e2203914e37832b9c8f258694099f8bbce16"
    sha256 cellar: :any_skip_relocation, ventura:        "0e60767c4c4c5667421d4a0d7aed2ac4cbaa0e7be93cd79d8b8bfb20e7caa96c"
    sha256 cellar: :any_skip_relocation, monterey:       "d68ec14be317d74046a9fa162510c5504599ea493ccc3b74c37e875e2bfa8b55"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1fbcb9cfa9ee8a2a142a62b69903a020b1f9a136936fb84a7ad0e96d44a9771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e97454343ec4c6a95db2cfacbe9b8208bd3eaa8f0c0bad1338330b48de289229"
  end

  depends_on "keyring"
  depends_on "pillow"
  depends_on "python-certifi"
  depends_on "python-lxml"
  depends_on "python-tabulate"
  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "libffi"

  on_linux do
    depends_on "cffi"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/af/0b/44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094/beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/fb/00/20a7ddef854c51347165d114c879203d656e12f7d9b7b30dd8cd244adcf1/boto3-1.28.40.tar.gz"
    sha256 "6ff9a5b815e106656596064d51c9b6ba97a307807baa5f89634384b7d3f7ecc6"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/96/b2/810868e32687760da8666ca65d2e307d7f50ed38276b5aef6cdf0a9fde14/botocore-1.31.40.tar.gz"
    sha256 "ce22a82ef8674f49691477d09558992cc87e7331f65c6a5b0da897ab192240ca"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/0b/65/bad3eb64f30657ee9fa2e00e80b3ad42037db5eb534fadd15a94a11fe979/configparser-6.0.0.tar.gz"
    sha256 "ec914ab1e56c672de1f5c3483964e68f71b34e457904b7b76e06b922aec067a8"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/5a/47/f1f3f5b6da710d5a7178a7f8484d9b86b75ee596fb4fefefb50e8dd2205a/filelock-3.12.3.tar.gz"
    sha256 "0ecc1dd2ec4672a10c8550a8182f1bd0c0a5088470ecd5a125e45f49472fac3d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "keyrings-alt" do
    url "https://files.pythonhosted.org/packages/a6/97/c7344bed881cc6f78b6231262436eb0c72615011fab4786d23d676ab77b0/keyrings.alt-5.0.0.tar.gz"
    sha256 "9d446cb47bbcea90ffa2ecc3e8003acf41573fc201bf44b4bf13bd0e11484828"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/5a/47/d676353674e651910085e3537866f093d2b9e9699e95e89d960e78df9ecf/s3transfer-0.6.2.tar.gz"
    sha256 "cab66d3380cca3e70939ef2255d01cd8aece6a4907a9528740f668c4b0611861"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/ee/f5/3e644f08771b242f7460438cdc0aaad4d1484c1f060f1e52f4738d342983/tzlocal-5.0.1.tar.gz"
    sha256 "46eb99ad4bdb71f3f72b7d24f4267753e240944ecfc16f25d2719ba89827a803"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
  end

  def install
    virtualenv_install_with_resources

    # we depend on keyring, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    keyring = Formula["keyring"].opt_libexec
    (libexec/site_packages/"homebrew-keyring.pth").write keyring/site_packages
  end

  test do
    auth_process = IO.popen "#{bin}/aws-google-auth"
    sleep 10
    Process.kill "TERM", auth_process.pid
    assert_match "AWS Region:", auth_process.read
  end
end
