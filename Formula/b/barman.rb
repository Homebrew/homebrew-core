class Barman < Formula
  include Language::Python::Virtualenv

  desc "Backup and Recovery Manager for PostgreSQL"
  homepage "https://www.pgbarman.org/"
  url "https://github.com/EnterpriseDB/barman/releases/download/release%2F3.19.1/barman-3.19.1.tar.gz"
  sha256 "2f71c4a1f1ba53f694cbdf838bb9906d8ba02b97d1fd3041196e8999bec7a1ee"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "238fae0eaf5353ff5ce5d49a915678ddcf54fe746c6bc9e2aaa35a919bdf1d16"
    sha256 cellar: :any,                 arm64_sequoia: "bf705af8b0e6dd0d627c7a5a96a49144434d6a6909b562dbb389bb6441aa6997"
    sha256 cellar: :any,                 arm64_sonoma:  "434ba26147d2d248c4b9af59ca05ad145911b5364b4257b0bba7c8834833087f"
    sha256 cellar: :any,                 sonoma:        "0e3b71ce18a1c8e4f8dbed22fc824939cd9067bca186f68cba8c7b051536ea08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "208680e61edf927fe9bb46430653b5fbfb9a7a2093c63462e08e3718b1c3a377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f5011eb88f1b8b29e54acd4926426939cea609a95da5c3b0b20f81736c542ed"
  end

  depends_on "libpq"
  depends_on "openssl@3"
  depends_on "python@3.14"

  resource "psycopg2" do
    url "https://files.pythonhosted.org/packages/c7/bc/f66df707ed1aec949fbf24e4460e4f4277a7ba23cdadb3965bb1f634ddb9/psycopg2-2.9.12.tar.gz"
    sha256 "1dedb1c7a1d8552c4a6044c6b1c41a52e6a8e2d144af83eccac758076b1b7c15"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4f/db/cfac1baf10650ab4d1c111714410d2fbb77ac5a616db26775db562c8fab2/setuptools-82.0.1.tar.gz"
    sha256 "7d872682c5d01cfde07da7bccc7b65469d3dca203318515ada1de5eda35efbf9"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    virtualenv_install_with_resources
    etc.install "docs/barman.conf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/barman --version")

    cp etc/"barman.conf", testpath
    inreplace "barman.conf", "barman_user = barman", "barman_user = #{ENV["USER"]}"
    system bin/"barman", "-c", "barman.conf", "list-servers"
  end
end
