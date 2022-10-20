class Epr < Formula
  include Language::Python::Virtualenv

  desc "Command-line EPUB reader"
  homepage "https://github.com/wustho/epr"
  url "https://files.pythonhosted.org/packages/39/20/d647083aa86ec9da89b4f04b62dd6942aabb77528fd2efe018ff1cd145d2/epr-reader-2.4.15.tar.gz"
  sha256 "a5cd0fbab946c9a949a18d0cb48a5255b47e8efd08ddb804921aaaf0caa781cc"
  license "MIT"
  head "https://github.com/wustho/epr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b73999619b53746727b7cc40ff1f020187b04e3e5070f3db945bdbba2fa1aa8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b872410fa327264b5a98264b74aa98e8549442262022520bfbb943e1a3f3a509"
    sha256 cellar: :any_skip_relocation, monterey:       "e7c7acb3bcf5231b4b4a5e15832935d9fb2293f892c3502c8cdb33e99080d13b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0391b30e86412bbe3d3775d04b16be13d216f0102207112c3d97aed2639dc8d"
    sha256 cellar: :any_skip_relocation, catalina:       "febe96e73961846928c0bf207b1a61553504449b16e5bf73ab9623ca78f50207"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e35e0f7d961dfc20800683b1b97b15bdce8ce4756282041ec45b389e2e42c56a"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Reading history:", shell_output("#{bin}/epr -r")
  end
end
