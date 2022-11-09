class Bandit < Formula
  include Language::Python::Virtualenv

  desc "Security-oriented static analyser for Python code"
  homepage "https://github.com/PyCQA/bandit"
  url "https://files.pythonhosted.org/packages/39/36/a37a2f6f8d0ed8c3bc616616ed5019e1df2680bd8b7df49ceae80fd457de/bandit-1.7.4.tar.gz"
  sha256 "2d63a8c573417bae338962d4b9b06fbc6080f74ecd955a092849e1e65c717bd2"
  license "Apache-2.0"
  head "https://github.com/PyCQA/bandit.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "915f962f89f0cf0ae432a4fc72901c4529a66a280b22a6d44306efcdc716ff80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1e17670712be6fee6d21317c108098e3d5144708d133f218deeeaa797c9d98b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43bd465a694df50d4c6d305d947ee3df3b9d011629a6070ea4960af73a0aa991"
    sha256 cellar: :any_skip_relocation, monterey:       "058d08e4c08317f2516696e3ab71e4145ab8d48106a26edb84be0a2e9c066ba0"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9abf0e13a3b93ee4711cb3524b8e404a5e0dc17ed1c17174477a888218e85eb"
    sha256 cellar: :any_skip_relocation, catalina:       "c4d190831b21b6110bb3eab21f79406e94b196a57188a744fa137b45fcc00552"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20277723685bcd548b17fcf4639d6ba3bbc3a1638c091b5612816d04f7eb2d15"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/fc/44/64e02ef96f20b347385f0e9c03098659cb5a1285d36c3d17c56e534d80cf/gitdb-4.0.9.tar.gz"
    sha256 "bac2fd45c0a1c9cf619e63a90d62bdc63892ef92387424b855792a6cabe789aa"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/22/ab/3dd8b8a24399cee9c903d5f7600d20e8703d48904020f46f7fa5ac5474e9/GitPython-3.1.29.tar.gz"
    sha256 "cc36bfc4a3f913e66805a28e84703e419d9c264c1077e537b54f0e1af85dbefd"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/52/fb/630d52aaca8fc7634a0711b6ae12a0e828b6f9264bd8051225025c3ed075/pbr-5.11.0.tar.gz"
    sha256 "b97bc6695b2aff02144133c2e7399d5885223d42b7912ffaec2ca3898e673bfe"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/62/4c/5445ea215b920e55f40a4f519571d5bfffb81c2f0c9ba4f2c70b1b501954/stevedore-4.1.0.tar.gz"
    sha256 "02518a8f0d6d29be8a445b7f2ac63753ff29e8f2a2faa01777568d5500d777a6"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write "assert True\n"
    output = JSON.parse shell_output("#{bin}/bandit -q -f json test.py", 1)
    assert_equal output["results"][0]["test_id"], "B101"
  end
end
