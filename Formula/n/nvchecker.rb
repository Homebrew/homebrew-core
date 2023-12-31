class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/0b/e2/1d749d02d1625529571cc01aad4e3e23d834fbe58bfca1a2bf3bb86a8b65/nvchecker-2.13.1.tar.gz"
  sha256 "50594215ebf23f12795886f424b963b3e6fab26407a4f9afc111df4498304ee3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a000e8b576e6374c7c0ddbe9b6298ec5c5f9eb1bc4ed106a80d623ed35e78e93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "560de7f59bad09be29404b057e60294fa62edbc1bc5de849b0b647dafc86c123"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c65067d60d35567611d6a0330aadc2b4b217cd9628e7eea614086f28a1d4d88"
    sha256 cellar: :any_skip_relocation, sonoma:         "23b43e2e46bc411062e46258a773149607af1017212df38aaeb7d332aec896be"
    sha256 cellar: :any_skip_relocation, ventura:        "029c3caf48063c791de0217fa98c1d1a08f758b7156b1b9cf4535dce7bffab1b"
    sha256 cellar: :any_skip_relocation, monterey:       "897c7b1da174961f08f39be54364a843ae05da7738e414865d3acba1349d5ddb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "875ab422746cd4c1f67c06303a987efe7807fa135573de8f7e29d7650e5a28c2"
  end

  depends_on "jq" => :test
  depends_on "python-packaging"
  depends_on "python-pycurl"
  depends_on "python@3.12"

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/62/d1/7feaaacb1a3faeba96c06e6c5091f90695cc0f94b7e8e1a3a3fe2b33ff9a/platformdirs-4.1.0.tar.gz"
    sha256 "906d548203468492d432bcb294d4bc2fff751bf84971fbb2c10918cc206ee420"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/99/4c/67e8cc235bbeb0a87053739c4c9d0619e3f284730ebdb2b34349488d9e8a/structlog-23.2.0.tar.gz"
    sha256 "334666b94707f89dbc4c81a22a8ccd34449f0201d5b1ee097a030b577fa8c858"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/bd/a2/ea124343e3b8dd7712561fe56c4f92eda26865f5e1040b289203729186f2/tornado-6.4.tar.gz"
    sha256 "72291fa6e6bc84e626589f1c29d90a5a6d593ef5ae68052ee2ef000dfd273dee"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    file = testpath/"example.toml"
    file.write <<~EOS
      [nvchecker]
      source = "pypi"
      pypi = "nvchecker"
    EOS

    out = shell_output("#{bin}/nvchecker -c #{file} --logger=json | jq '.[\"version\"]' ").strip
    assert_equal "\"#{version}\"", out
  end
end
