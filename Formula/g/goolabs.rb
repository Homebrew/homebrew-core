class Goolabs < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool for morphologically analyzing Japanese language"
  homepage "https://pypi.python.org/pypi/goolabs"
  url "https://files.pythonhosted.org/packages/ce/86/2d3b5bd85311ee3a7ae7a661b3619095431503cd0cae03048c646b700cad/goolabs-0.4.0.tar.gz"
  sha256 "4f768a5b98960c507f5ba4e1ca14d45e3139388669148a2750d415c312281527"
  license "MIT"
  revision 6

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e658052b927f381ded8fb29e51fb483413f4dfd2d968deb0f3b4655917246a00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6545d30e95c943fa46d1481957ecea03ec0d709ffc62d144ea2ae828ade14ff7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfcb5b0d948d2d06610af5886da741a7fa508070b6ef21a5d9faeb5e5c1a9f2c"
    sha256 cellar: :any_skip_relocation, ventura:        "f11c2742812fa86aaf19206ddeb4556579cc4e96da09ef131fc228def2d083fd"
    sha256 cellar: :any_skip_relocation, monterey:       "2cc76a7b0ce3b7e4356d8a36835a88bf4cb6478c8f83b78b9be37187119ff61c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3b62af966862d5608ac825a11735bedc17f57a2274be3297b7e091740a9014e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bce094e87867d9b40980d969a9f5b5fe12f0062b604289fcdeeaf62ff8510faf"
  end

  depends_on "python-certifi"
  depends_on "python@3.11"
  depends_on "six"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/72/bd/fedc277e7351917b6c4e0ac751853a97af261278a4c7808babafa8ef2120/click-8.1.6.tar.gz"
    sha256 "48ee849951919527a045bfe3bf7baa8a959c423134e1a5b98c05c20ba75a1cbd"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Usage: goolabs morph", shell_output("#{bin}/goolabs morph test 2>&1", 2)
  end
end
