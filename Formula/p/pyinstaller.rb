class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/5c/b5/79e53c645c3f458cde165493ed71c1cac478fce67f204ad6ecca48b47440/pyinstaller-6.3.0.tar.gz"
  sha256 "914d4c96cc99472e37ac552fdd82fbbe09e67bb592d0717fcffaa99ea74273df"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b72481dddaba2d38a5ca2e7753005e3232ef497688efc84d888f2a4178391a9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5daadc7ee35fa7d6e06d3c990157a4595bea858ba84022d6a5a02efbb06aa9ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "619de43f2e36ffad2f08f2a5482bf4f824c5ce54d1288d612cd6de6a8dd47b76"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa8908395a2a9572f2241193cbbe288d9a03beb93a978869f85bf0eca8ff09d9"
    sha256 cellar: :any_skip_relocation, ventura:        "cc56875b9364235bf1d6832ba441d6142824ef5e9834688f81a7fb6be2c5483b"
    sha256 cellar: :any_skip_relocation, monterey:       "9bdc002d04aed1e558da92d0aa48227196298bca3681fbc69d21f950d29a009e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f1dee79bfa5d925799ecab74aa8d7a691c261f65998f6ddb7368704eff1ebde"
  end

  depends_on "python-packaging"
  depends_on "python-setuptools"
  depends_on "python@3.12"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/de/a8/7145824cf0b9e3c28046520480f207df47e927df83aa9555fb47f8505922/altgraph-0.17.4.tar.gz"
    sha256 "1b5afbb98f6c4dcadb2e2ae6ab9fa994bbb8c1d75f4fa96d340f9437ae454406"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/95/ee/af1a3842bdd5902ce133bd246eb7ffd4375c38642aeb5dc0ae3a0329dfa2/macholib-1.16.3.tar.gz"
    sha256 "07ae9e15e8e4cd9a788013d81f5908b3609aa76f9b1421bae9c4d7606ec86a30"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/3d/e0/d41437880dc87abfc28cb6ae965d113dfd9d7151ef61223b71488062a114/pyinstaller-hooks-contrib-2023.10.tar.gz"
    sha256 "4b4a998036abb713774cb26534ca06b7e6e09e4c628196017a10deb11a48747f"
  end

  def install
    cd "bootloader" do
      system "python3.12", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
    end
    virtualenv_install_with_resources
  end

  test do
    (testpath/"easy_install.py").write <<~EOS
      """Run the EasyInstall command"""

      if __name__ == '__main__':
          from setuptools.command.easy_install import main
          main()
    EOS
    system bin/"pyinstaller", "-F", "--distpath=#{testpath}/dist", "--workpath=#{testpath}/build",
                              "#{testpath}/easy_install.py"
    assert_predicate testpath/"dist/easy_install", :exist?
  end
end
