class Diceware < Formula
  include Language::Python::Virtualenv

  desc "Passphrases to remember"
  homepage "https://github.com/ulif/diceware"
  url "https://files.pythonhosted.org/packages/2f/7b/2ebe60ee2360170d93f1c3f1e4429353c8445992fc2bc501e98013697c71/diceware-0.10.tar.gz"
  sha256 "b2b4cc9b59f568d2ef51bfdf9f7e1af941d25fb8f5c25f170191dbbabce96569"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "681a742488bc20ae096c628a5ac2e4d9f979821b43a5a0b1daf3f03193da142e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9ae808ef971b35d938fd9462698108a89b35c1d9418a9151186c1912430c9b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9830e1d1a3f676c2f7770e57d53b1816f6358d5f1cd4817e989523f8bbacd035"
    sha256 cellar: :any_skip_relocation, sonoma:         "5829088526f79a5ada0f9d95a155fd4dd1ed019ccfa01f661239d06e69cbd8c5"
    sha256 cellar: :any_skip_relocation, ventura:        "ad4aa23750b9b06f946f68ead8fc509fe3419b0461d938f20f94b336236d274c"
    sha256 cellar: :any_skip_relocation, monterey:       "5f20c464e18bb82300f76c18d783fe9aac841d554360cd4c44fc801651d649c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61d3f337b990f1d738d153894f7f6250254f0960a9d2326fc3ca84e7fa37a3cf"
  end

  depends_on "python-setuptools" # remove for v0.11+
  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
    man1.install "diceware.1"
  end

  test do
    assert_match(/(\w+)(-(\w+)){5}/, shell_output("#{bin}/diceware -d-"))
  end
end
