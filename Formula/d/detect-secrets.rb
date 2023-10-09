class DetectSecrets < Formula
  include Language::Python::Virtualenv

  desc "Enterprise friendly way of detecting and preventing secrets in code"
  homepage "https://github.com/Yelp/detect-secrets"
  url "https://files.pythonhosted.org/packages/f1/55/292f9ce52bba7f3df0a9cde65dabf458d3aeec6a63bf737e5a5fa9fe6d31/detect_secrets-1.4.0.tar.gz"
  sha256 "d56787e339758cef48c9ccd6692f7a094b9963c979c9813580b0169e41132833"
  license "Apache-2.0"
  revision 2
  head "https://github.com/Yelp/detect-secrets.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef654869fd6f2c61ad9c5bc9af706c79a2e836672de72356fba891f4d6354ff2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bc89867c5500ed09d2851c3cc678bc1a11f845c230bc6fe6628468b44d59dc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be5a6b6bfb144ee3c91bacca0d4ac565d7e0157c5ac15f2f3d43a11aae487ad5"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8d199e035a9258b168dae7a38dd7f8f80bc91930bfe7fc1ed1b851bbc7f5712"
    sha256 cellar: :any_skip_relocation, ventura:        "6939d0013b6dd944397a03f705396d4d6f22ecf9e77d55e5c4fa5ca325eb5ad1"
    sha256 cellar: :any_skip_relocation, monterey:       "5f8b5ca88444faefc5735e6fc8e2017e0eee51a458f25d5c8c886d735b85f7ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90e55cc963109f5adf53fc8ac9d4af58ec9b0c6cce5672e480053c5e73afd9f4"
  end

  depends_on "python-certifi"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
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
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "ArtifactoryDetector", shell_output("#{bin}/detect-secrets scan --list-all-plugins 2>&1")
  end
end
