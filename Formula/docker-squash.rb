class DockerSquash < Formula
  include Language::Python::Virtualenv

  desc "Docker image squashing tool"
  homepage "https://github.com/goldmann/docker-squash"
  url "https://files.pythonhosted.org/packages/7d/f8/23a9721de4888be7eb59e21d2d4c86da8273d3fa4535052f153b4b8bfacf/docker-squash-1.0.10.tar.gz"
  sha256 "cf88e2f23e0de109c6636acbdd5c705fa4a6a33a783bdb087f700bcd09cf8683"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2114c4559e0a9a0e3746b6d9aa602949f29c89a51571bb609de9ea96f3a768a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47dbd1e54670c623bb18c13347188fbb0b6afdb3ad3579fa4b0bcaae5d5eecaf"
    sha256 cellar: :any_skip_relocation, monterey:       "ae1572cab25ea6c752722b874f409b4ec775d8a1a555061eb37e7f1608391a8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "62b711591dc289d909164dcd5479b7b772993212279abc166c7e8c644554e8d1"
    sha256 cellar: :any_skip_relocation, catalina:       "ecd21784411e1ca7bb98a27783d6c9801c71da3519e7ce7d7501dc1789d76fd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b351c4743259241f6460339e7aee1b48874f93fc847e1a47814b13a57d71f97b"
  end

  depends_on "python@3.10"
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
    url "https://files.pythonhosted.org/packages/1a/d1/c41d51a0b5192533885545e031ee1b98ee6dc93ceb0c1deb4ecfe212a9a8/docker-6.0.0.tar.gz"
    sha256 "19e330470af40167d293b0352578c1fa22d74b34d3edf5d4ff90ebc203bbb2f1"
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
    url "https://files.pythonhosted.org/packages/99/11/01fe7ebcb7545a1990c53c11f31230afe1388b0b34256e3fd20e49482245/websocket-client-1.4.1.tar.gz"
    sha256 "f9611eb65c8241a67fb373bef040b3cf8ad377a9f6546a12b620b6511e8ea9ef"
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
