class NameThatHash < Formula
  include Language::Python::Virtualenv

  desc "Modern hash identification system"
  homepage "https://nth.skerritt.blog/"
  url "https://files.pythonhosted.org/packages/7a/d6/5bea2b09a8b4dbfd92610432dbbcdda9f983be3de770a296df957fed5d06/name_that_hash-1.11.0.tar.gz"
  sha256 "6978a2659ce6d38c330ab8057b78bccac00bc3e87138f2774bec3af2276b0303"
  license "GPL-3.0-or-later"
  head "https://github.com/HashPals/Name-That-Hash.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4020cbb09cbe8736a98bf84fce42b9a56391abc6cf425ce4b0891e758b10b7b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e6c3c27debfd317c58804ec0261ff40656d85672551c24eb120d7df4b8aca09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b19a1655bc7711f5c231b30851812cd9e79e8af1a2733ad8f58796a4b9f693c"
    sha256 cellar: :any_skip_relocation, ventura:        "4b12a7e90ccd7ff34b8f65a250ee64c6ad5e41d63e01c8b3d0651ea85b57913f"
    sha256 cellar: :any_skip_relocation, monterey:       "a4cc533509369346aa8386b3e91327bc0b5a2838916229ce8d8fafac70ac239f"
    sha256 cellar: :any_skip_relocation, big_sur:        "504dbe235e16c8321c68bbcfce7258b24af6da3d754d5b9d11882da7c71d2c6a"
    sha256 cellar: :any_skip_relocation, catalina:       "ad00a4e99937b98ac9c1e317e8d3e544bc954a46b9fcbc4fdef343ce381a97f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5635edb4f1faa51b8096a8b55e73e22e95319634a29421e800c808e15ba5a721"
  end

  depends_on "python@3.11"

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/e0/ef/5905cd3642f2337d44143529c941cc3a02e5af16f0f65f81cbef7af452bb/Pygments-2.13.0.tar.gz"
    sha256 "56a8508ae95f98e2b9bdf93a6be5ae3f7d8af858b43e02c5a2ff083726be40c1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/11/23/814edf09ec6470d52022b9e95c23c1bef77f0bc451761e1504ebd09606d3/rich-12.6.0.tar.gz"
    sha256 "ba3a3775974105c221d31141f2c116f4fd65c5ceb0698657a11e9f295ec93fd0"
  end

  def python3
    "python3.11"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages(python3)
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-name_that_hash.pth").write pth_contents
  end

  test do
    hash = "5f4dcc3b5aa765d61d8327deb882cf99"
    output = shell_output("#{bin}/nth --text #{hash}")
    assert_match "#{hash}\n", output
    assert_match "MD5, HC: 0 JtR: raw-md5 Summary: Used for Linux Shadow files.\n", output

    system python3, "-c", "from name_that_hash import runner"
  end
end
