class MongoOrchestration < Formula
  include Language::Python::Virtualenv

  desc "REST API to manage MongoDB configurations on a single host"
  homepage "https://github.com/10gen/mongo-orchestration"
  url "https://files.pythonhosted.org/packages/80/bc/46ec328dcb9abcc8e9956c02378bfd4bfb053cb94fcf40b62b75f900d147/mongo-orchestration-0.8.0.tar.gz"
  sha256 "9cb17a4f1a19d578a04c34ef51f4d5bc2a1c768f4968948792f330644c9398f6"
  license "Apache-2.0"
  revision 1
  head "https://github.com/10gen/mongo-orchestration.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0884101bc25982a442d27a1503f42a4a95d3b62f56ec3f91e010bf3f58746814"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f3a32fd2fdf01f8c1ba8b95f525e3a7168f1abc8914d14e715dc76350e9a0f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4afc69e2e454af89a58911bf0308794d03a628fd90b974e28a4ebf2b01ce8e93"
    sha256 cellar: :any_skip_relocation, ventura:        "69d7e56f87266880d7430f0a226c07631968d937567786a733e827e30cc7e73d"
    sha256 cellar: :any_skip_relocation, monterey:       "7e533ffc23e27afbc26e5b1b713bbddc24dd12ce523cdbb22a35dc3271658a02"
    sha256 cellar: :any_skip_relocation, big_sur:        "15a1d3f33b5f7dd2a8e8de50a3092a37c119863fd1a2f442e96be01d5b22de64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b4a2428b60fe93108e399f4576b733d8a31dcb9ffcdeda0121ca428b644f490"
  end

  depends_on "python-certifi"
  depends_on "python@3.11"
  depends_on "six"

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/fd/04/1c09ab851a52fe6bc063fd0df758504edede5cc741bd2e807bf434a09215/bottle-0.12.25.tar.gz"
    sha256 "e1a9c94970ae6d710b3fb4526294dfeb86f2cb4a81eff3a4b98dc40fb0e5e021"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "cheroot" do
    url "https://files.pythonhosted.org/packages/08/7c/95c154177b16077de0fec1b821b0d8b3df2b59c5c7b3575a9c1bf52a437e/cheroot-10.0.0.tar.gz"
    sha256 "59c4a1877fef9969b3c3c080caaaf377e2780919437853fc0d32a9df40b311f0"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/78/ad/db7b362200e11378d1d286a4452c7050dab47b0e6d99afa51364ad95a9f9/dnspython-2.4.1.tar.gz"
    sha256 "c33971c79af5be968bb897e95c2448e11a645ee84d93b265ce0b7aabe5dfdca8"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/99/62/3c214a2a6143701690af6a6687f324af93f6cb0222eee6dddd8196fcfd05/jaraco.functools-3.8.0.tar.gz"
    sha256 "cb5635ae5cc953d35d8ab6744f1a73723074b31eb6be16edee7960261a79b724"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/b7/56/7daf104a9cb6af39c00127aee6904b01040dbb12cf1ceedd6a087c097055/more-itertools-10.0.0.tar.gz"
    sha256 "cd65437d7c4b615ab81c0640c0480bc29a550ea032891977681efd28344d51e1"
  end

  resource "pymongo" do
    url "https://files.pythonhosted.org/packages/bf/1c/38b956d48667745f2f083937dd31b0467fa3f537480e30c692b1fc4fef3d/pymongo-4.4.1.tar.gz"
    sha256 "a4df87dbbd03ac6372d24f2a8054b4dc33de497d5227b50ec649f436ad574284"
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

  service do
    run [opt_bin/"mongo-orchestration", "-b", "127.0.0.1", "-p", "8889", "--no-fork", "start"]
    require_root true
  end

  test do
    system "#{bin}/mongo-orchestration", "-h"
  end
end
