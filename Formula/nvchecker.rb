class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/02/08/ee78cbb49fcbafbf566546439368a87466763a698f1483aeb93c0f4bdda2/nvchecker-2.11.tar.gz"
  sha256 "80d22af6bcdfa08a336b086eca98cef863ae21ca8a4822e2577075e2bca6cf00"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e551381109835b19d2f1ce0773d284f2fc66d1f0dace2d7092b04cd7549e752"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "042a0f9f0f041f35f62199ba7b66e2e85b2450ccd0e41f6c0469a796d60ff069"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1634e545aa0fff727fb5202670eb35aa7177703439afabfe75c7cbe63ac0496"
    sha256 cellar: :any_skip_relocation, ventura:        "294fe053176313442262654518fd8a287670079d2cc62a9e08e5ec92b32241f0"
    sha256 cellar: :any_skip_relocation, monterey:       "388f71246fea0528a261189a3d5e4ecd8bd2b16f6d63d85671722cf232aa33aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "46f875a1c7e28df40183c78daf005ae22d94a33fe8606c55c6d0edd1bfbd5304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83fadfb67eee1c182e2b1aa76e85e8960c34c750c55fd343918e06a8a96ab4a7"
  end

  depends_on "jq" => :test
  depends_on "python@3.11"

  uses_from_macos "curl"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/15/04/3f882b46b454ab374ea75425c6f931e499150ec1385a73e55b3f45af615a/platformdirs-3.2.0.tar.gz"
    sha256 "d5b638ca397f25f979350ff789db335903d7ea010ab28903f57b27e1b16c2b08"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/a8/af/24d3acfa76b867dbd8f1166853c18eefc890fc5da03a48672b38ea77ddae/pycurl-7.45.2.tar.gz"
    sha256 "5730590be0271364a5bddd9e245c9cc0fb710c4cbacbdd95264a3122d23224ca"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/9e/c4/688d14600f3a8afa31816ac95220f2548648e292c3ff2262057aa51ac2fb/structlog-23.1.0.tar.gz"
    sha256 "270d681dd7d163c11ba500bc914b2472d2b50a8ef00faa999ded5ff83a2f906b"
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
