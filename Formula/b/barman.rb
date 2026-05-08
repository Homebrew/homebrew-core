class Barman < Formula
  include Language::Python::Virtualenv

  desc "Backup and Recovery Manager for PostgreSQL"
  homepage "https://www.pgbarman.org/"
  url "https://github.com/EnterpriseDB/barman/releases/download/release%2F3.18.0/barman-3.18.0.tar.gz"
  sha256 "8e752ac93d2f3a61e86b8374185209cae477a638ece7e6f540070f36d28d6997"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cbf037220fca3b11693a2e177c7153a51a1bc3a6c6b544982e19d5dfb87ec318"
    sha256 cellar: :any,                 arm64_sequoia: "658323a578c91207d8d45366c5e6842dd1005c23548393938066cfb433ae302a"
    sha256 cellar: :any,                 arm64_sonoma:  "5b77eabb82079812bc51c5bff8c6fe8faaa445c904d2c2f2927c5e16c49922c4"
    sha256 cellar: :any,                 sonoma:        "ddd07eeaa1f099155176ce6715937a9fb68ab3d8eb1cdc25f2f849b0781bbc59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8612bd10ce6dea6dd2725ee5a920b8d866290d6649fb8eaad4e7c2e790a7f02d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23bb43cba5f2d7a2c9aff2df01e0d2392163c3cd4a004ee4c752f65433c296eb"
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
