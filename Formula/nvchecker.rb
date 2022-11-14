class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/37/64/ca6d00c941935485ae41f699aa06d701497e8120f5c09df44e6f90149634/nvchecker-2.10.tar.gz"
  sha256 "11b4b638c8bed798adbec9e52767633e7e43283adcdde90016ec372277bd9b08"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20ec545013975b09051bc6633325c1a1895311d7013d9175fb0d376267f3d6ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bdd1db64a899fdae2d8993acf71621c1238bc52351e9e0f53e72313e5c8ffb1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb968b43b84fe58328e9d86dd90de26217ed780f92e65856bc92a7adaf57dfa7"
    sha256 cellar: :any_skip_relocation, monterey:       "9dd0aef3d42132354fcc53d8d156eb3d0d49d8e1957935abfaaf37a102148874"
    sha256 cellar: :any_skip_relocation, big_sur:        "2386a26e194ece390a0ecc32b916f395c79fb0f15e7933f616ad56a7e7f109f4"
    sha256 cellar: :any_skip_relocation, catalina:       "3b94c562e4e11bcbb3a08dc4eb58ef0a0058d9dc318f951deab3c8ce97cc9177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3403c3543259cdaffc9c7df463457b7e70d55c0676c8f98bb77ed49b82ae0328"
  end

  depends_on "jq" => :test
  depends_on "python@3.11"

  uses_from_macos "curl"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/09/ca/0b6da1d0f391acb8991ac6fdf8823ed9cf4c19680d4f378ab1727f90bd5c/pycurl-7.45.1.tar.gz"
    sha256 "a863ad18ff478f5545924057887cdae422e1b2746e41674615f687498ea5b88a"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/2b/d4/359d0313ba3e7080cc943b515640b9e301f51abf196008c83c765d939df5/structlog-22.1.0.tar.gz"
    sha256 "94b29b1d62b2659db154f67a9379ec1770183933d6115d21f21aa25cfc9a7393"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/f3/9e/225a41452f2d9418d89be5e32cf824c84fe1e639d350d6e8d49db5b7f73a/tornado-6.2.tar.gz"
    sha256 "9b630419bde84ec666bfd7ea0a4cb2a8a651c2d5cccdbdd1972a0c859dfc3c13"
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
