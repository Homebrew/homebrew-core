class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/b0/98/170e3117657366560f355c154a5f4e1b9e6aee53c4f35127fe0c9aecb0e9/pyinstaller-6.11.0.tar.gz"
  sha256 "cb4d433a3db30d9d17cf5f2cf7bb4df80a788d493c1d67dd822dc5791d9864af"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83fed535bf08faf270526e352e43775000f4934b1e59144c2d5a05ba2f351e96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c165dda7e3b36752864cc8c8c7b92ddc9f6f0f524f1f381e2b91a2e02ccfae8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "582cb6d5cddd5633013941d3e6dbc941d589b7dc23c9ac2de86036ae2ced2b31"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad28212fa11caee765b48a6976209f4c83f0f30d307b1bb65a0cff8058029cca"
    sha256 cellar: :any_skip_relocation, ventura:       "8ea2991ef853fab32ce06c9dc4888fefb12ab99aabcbf67b12a0592270308e21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae442d5bfbf5baf87e11f09827aea7f0a5147b055f0155e87607cd88874ee6ef"
  end

  depends_on "python@3.13"

  uses_from_macos "zlib"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/de/a8/7145824cf0b9e3c28046520480f207df47e927df83aa9555fb47f8505922/altgraph-0.17.4.tar.gz"
    sha256 "1b5afbb98f6c4dcadb2e2ae6ab9fa994bbb8c1d75f4fa96d340f9437ae454406"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/95/ee/af1a3842bdd5902ce133bd246eb7ffd4375c38642aeb5dc0ae3a0329dfa2/macholib-1.16.3.tar.gz"
    sha256 "07ae9e15e8e4cd9a788013d81f5908b3609aa76f9b1421bae9c4d7606ec86a30"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/fe/ca/218b8dc15d48e69fafef69a97a4455db7a01c01aea4eb4bf1ae8a6ad7ef9/pyinstaller_hooks_contrib-2024.9.tar.gz"
    sha256 "4793869f370d1dc4806c101efd2890e3c3e703467d8d27bb5a3db005ebfb008d"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  end

  def install
    cd "bootloader" do
      system "python3.13", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
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
