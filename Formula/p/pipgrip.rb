class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/10/b5/fbca40a14be2772f436a0fad2851db906ca1642d46664757267a7fca9503/pipgrip-0.11.0.tar.gz"
  sha256 "5bde0d03fa7bf33c3f2e37bbc636071547224fb1aa21f246309cd007e8cec2e0"
  license "BSD-3-Clause"
  head "https://github.com/ddelange/pipgrip.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67752a5234171ce8d055afd391c179f19e7cf98984b005228c649ed22f330957"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67752a5234171ce8d055afd391c179f19e7cf98984b005228c649ed22f330957"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67752a5234171ce8d055afd391c179f19e7cf98984b005228c649ed22f330957"
    sha256 cellar: :any_skip_relocation, sonoma:        "754a6d084aba7b4916d82b4787e63ec71bf4d53b83185496688a8e3f693c26c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "754a6d084aba7b4916d82b4787e63ec71bf4d53b83185496688a8e3f693c26c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "754a6d084aba7b4916d82b4787e63ec71bf4d53b83185496688a8e3f693c26c2"
  end

  depends_on "python@3.14"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/bc/a8/eb55fab589c56f9b6be2b3fd6997aa04bb6f3da93b01154ce6fc8e799db2/anytree-2.13.0.tar.gz"
    sha256 "c9d3aa6825fdd06af7ebb05b4ef291d2db63e62bb1f9b7d9b71354be9d362714"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/8a/98/2d9906746cdc6a6ef809ae6338005b3f21bb568bea3165cfc6a243fdc25c/wheel-0.45.1.tar.gz"
    sha256 "661e1abd9198507b1409a20c02106d9670b2576e916d58f520316666abca6729"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"pipgrip", shell_parameter_format: :click)
  end

  test do
    assert_match "pip==25.0.1", shell_output("#{bin}/pipgrip --no-cache-dir pip==25.0.1")
    # Test gcc dependency
    assert_match "dxpy==", shell_output("#{bin}/pipgrip --no-cache-dir dxpy==0.394.0")
  end
end
