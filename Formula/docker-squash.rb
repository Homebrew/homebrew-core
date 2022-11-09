class DockerSquash < Formula
  include Language::Python::Virtualenv

  desc "Docker image squashing tool"
  homepage "https://github.com/goldmann/docker-squash"
  url "https://files.pythonhosted.org/packages/7d/f8/23a9721de4888be7eb59e21d2d4c86da8273d3fa4535052f153b4b8bfacf/docker-squash-1.0.10.tar.gz"
  sha256 "cf88e2f23e0de109c6636acbdd5c705fa4a6a33a783bdb087f700bcd09cf8683"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48d7f230325ffa4847da2daa35bb203964156a2dfd671e9a843cf7ef38efd78b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5ecdee9bcd1d12619de9f2f611341ca845d578060064422aee8117dad042fb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ffb30e5909ead6aa5587d5daa96803f6c2118527d37ebd254dbc10bcf355064"
    sha256 cellar: :any_skip_relocation, monterey:       "cc8c57aef19a8c0889edb5417946527eb49b01f2a043d4a7df1d695e2946b88e"
    sha256 cellar: :any_skip_relocation, big_sur:        "75f6e7f5e49e0a35012ea9119c093cade9e1ad2b70caded70859a21d5d4d4c9c"
    sha256 cellar: :any_skip_relocation, catalina:       "1d2bc20da4ba45da4bd872cfaaec1d493e7b62f7c9555bd5246302f792c6ab95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bad81d4dc6b0e17d015b15e7eabd296cbc092439b9761bfd63969e0dbce2ad8"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
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
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/75/af/1d13b93e7a21aca7f8ab8645fcfcfad21fc39716dc9dce5dc2a97f73ff78/websocket-client-1.4.2.tar.gz"
    sha256 "d6e8f90ca8e2dd4e8027c4561adeb9456b54044312dba655e7cae652ceb9ae59"
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
