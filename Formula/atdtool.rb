class Atdtool < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for After the Deadline language checker"
  homepage "https://github.com/lpenz/atdtool"
  url "https://files.pythonhosted.org/packages/83/d1/55150f2dd9afda92e2f0dcb697d6f555f8b1f578f1df4d685371e8b81089/atdtool-1.3.3.tar.gz"
  sha256 "a83f50e7705c65e7ba5bc339f1a0624151bba9f7cdec7fb1460bb23e9a02dab9"
  license "BSD-3-Clause"
  revision 4

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e63fb91618eec0e6af69227020acdd1e9b12fedd834fa68dabc34168ec5f4dfe"
    sha256 cellar: :any_skip_relocation, big_sur:       "ed0bcc8c78addd4e072c55d8476e8ed4d5d5b4942df5c48b359c483a6dc2949f"
    sha256 cellar: :any_skip_relocation, catalina:      "df0ff285c54b4368cb9e6731a025551c7e73f76a61f38b1e03cf86d8768735fb"
    sha256 cellar: :any_skip_relocation, mojave:        "267d97304c449f94707c4fac451331d1c9e38e07b774cc4fd78043a0bc94c197"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cdd57cf16b53626ffb5ad6a7a4f2c93069355665c4799a5922983464895a9a2"
  end

  deprecate! date: "2020-11-18", because: :repo_archived

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/atdtool", "--help"
  end
end
