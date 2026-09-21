class Barman < Formula
  include Language::Python::Virtualenv

  desc "Backup and Recovery Manager for PostgreSQL"
  homepage "https://www.pgbarman.org/"
  url "https://files.pythonhosted.org/packages/6a/f4/aa08320a5763e2be204379a0c384f8557a9de1d8b6a3de2d0f454f876b48/barman-3.20.0.tar.gz"
  sha256 "02dd8936e62c1829c78597eefedfcab0aa820f5618da2871f38b5bc684891a54"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6d359e52737cda9cb1c45a3219adc9434567abd3d5c0e3199e40256a46a99ac3"
    sha256 cellar: :any, arm64_tahoe:       "67aff887cf4c408e648b5956969a3d557ab52ee5efd472eccd7f18c4fc9fe018"
    sha256 cellar: :any, arm64_sequoia:     "7037114db5d16fd46256f06ae035f19e3fc0e259f9f2c5c7b5654e790fb2d23f"
    sha256 cellar: :any, arm64_sonoma:      "caba2aa9a13c8d8bc8ea1bee54831afd7caa446ed86f96801312d258a2e1defe"
    sha256 cellar: :any, arm64_linux:       "fbb8f2c4fb412734665d5238e4c40871b9dcc217baae3bb440535f5953c7da23"
    sha256 cellar: :any, x86_64_linux:      "1044127050d0ee8ace9de1d208a5cb60d4beebf5cb02ccb4fd8a3123e036e59b"
  end

  depends_on "rust" => :build # for uv_build > maturin
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
