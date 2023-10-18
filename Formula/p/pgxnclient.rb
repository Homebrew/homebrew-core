class Pgxnclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for the PostgreSQL Extension Network"
  homepage "https://pgxn.github.io/pgxnclient/"
  url "https://github.com/pgxn/pgxnclient/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "0d02a91364346811ce4dbbfc2f543356dac559e4222a3131018c6570d32e592a"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e01abaa6613e48a15ec27dbad5b04780761eb73c9e1edd5c5892efe5feff949"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75b13d5baad53bb3063a52ecb712c115f0f23ca321062d3b92088f17737a7912"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "321c393a89553c347f011274fe841840fb4e1847c0e93fed9134cd2e8ea9fa55"
    sha256 cellar: :any_skip_relocation, sonoma:         "73c2069d8d778a8646b98dbe4541af4c2bdf1a9cb756270a827e723daa292201"
    sha256 cellar: :any_skip_relocation, ventura:        "63a788e86374c7c0089a0cd9ebaa33adc282f47fa588eb0d51fe6d6471bdf04b"
    sha256 cellar: :any_skip_relocation, monterey:       "46caf982a9d58098f9489f3f35b955a0b87b789c0ea757b5b4b0a3bf1d016608"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f1b2b974561e440ebb0ec1c1f10e24a023e47397a9ecf43dda1c10463a3a96e"
  end

  depends_on "python@3.12"
  depends_on "six"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pgxn", shell_output("#{bin}/pgxnclient mirror")
  end
end
