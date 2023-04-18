class DockerSquash < Formula
  include Language::Python::Virtualenv

  desc "Docker image squashing tool"
  homepage "https://github.com/goldmann/docker-squash"
  url "https://files.pythonhosted.org/packages/7d/f8/23a9721de4888be7eb59e21d2d4c86da8273d3fa4535052f153b4b8bfacf/docker-squash-1.0.10.tar.gz"
  sha256 "cf88e2f23e0de109c6636acbdd5c705fa4a6a33a783bdb087f700bcd09cf8683"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf0c62b8723354ec5dfad884e18e2b3cd7a3694b9fc62c9c2e2db4239b77863a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "403c13d1e7f6a74fb3c9d92c55ee5d21c037ca135607e102204f3e01aa18105d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79e15a895d36531ac87ba617d2075f803d311ebd26f7a844d2f19c8ce3f3ebc6"
    sha256 cellar: :any_skip_relocation, ventura:        "ec799802efd9828bd21023fd3d89aab9bfd4ef3d8e07e6dc28f0da36aa3c2b55"
    sha256 cellar: :any_skip_relocation, monterey:       "37ad4f9d6671d0eab04868fc80621259df8106f8b2bf608bdc6e2e294d049bd8"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1d526a45df27a046f9615f77bc19cd04a6e79b335425c8a164376e73e8598d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "928b047b8fcdbfadb7c28c1cff520c535cd92e660aade405ae80868dd08530c6"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/96/d7/1675d9089a1f4677df5eb29c3f8b064aa1e70c1251a0a8a127803158942d/charset-normalizer-3.0.1.tar.gz"
    sha256 "ebea339af930f8ca5d7a699b921106c6e29c617fe9606fa7baa043c1cdae326f"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/79/26/6609b51ecb418e12d1534d00b888ce7e108f38b47dc6cd589598d5c6aaa2/docker-6.0.1.tar.gz"
    sha256 "896c4282e5c7af5c45e8b683b0b0c33932974fe6e50fc6906a0a83616ab3da97"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/8b/94/696484b0c13234c91b316bc3d82d432f9b589a9ef09d016875a31c670b76/websocket-client-1.5.1.tar.gz"
    sha256 "3f09e6d8230892547132177f575a4e3e73cfdf06526e20cc02aa1c3b47184d40"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["DOCKER_HOST"] = "does-not-exist:1234"
    output = shell_output("#{bin}/docker-squash not_an_image 2>&1", 1)
    assert_match "Could not create Docker client", output
  end
end
