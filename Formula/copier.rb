class Copier < Formula
  include Language::Python::Virtualenv

  desc "Utility for rendering projects templates"
  homepage "https://copier.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/67/95/911bb7c4e30333312cd372c09423acabe76986968aaa77482b2c479bad1e/copier-5.1.0.tar.gz"
  sha256 "4afec02c6fa3efcac73e89307a1fddce1b71bf43f2df2adc338b97b89949a59b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9714918846cfa9dbb4d04fdfce107f52763de8022bc9932cb70f63286a274011"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2532e865521de4e544c51240ebc3308723427b0acef2ded69c442e7bc0ba506"
    sha256 cellar: :any_skip_relocation, monterey:       "d316707485b0e0e6059d1517faf1994c3e8387932460505400f95489e93f3656"
    sha256 cellar: :any_skip_relocation, big_sur:        "315e1fbfdf6e02fd6a1732c7c5282b9dc7b2efccafd9e7282d720474028d6782"
    sha256 cellar: :any_skip_relocation, catalina:       "3f649c5619c31537d6d927efdc8646d38504f1f04afc3c3e7748983894da43b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd652d263a83b481e70ba076c2e9e3e1f6954106feb17c1923ab1bb0d0052238"
  end

  depends_on "poetry" => :build
  depends_on "python@3.10"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/4f/e7/65300e6b32e69768ded990494809106f87da1d436418d5f1367ed3966fd7/Jinja2-2.11.3.tar.gz"
    sha256 "a6d58433de0ae800347cab1fa3043cebbabe8baa9d29e668f1c768cb87a333c6"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/86/3c/bcd09ec5df7123abcf695009221a52f90438d877a2f1499453c6938f5728/packaging-20.9.tar.gz"
    sha256 "5b327ac1320dc863dca72f4514ecc086f31186744b84a230374cc1fd776feae5"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/b7/64/e097eea8dcd2b2f7df6e4425fc98e7494e37b1a6e149603c31d327080a05/pathspec-0.8.1.tar.gz"
    sha256 "86379d6b86d75816baba717e64b1a3a3469deb93bb76d613c9ce79edc5cb68fd"
  end

  resource "plumbum" do
    url "https://files.pythonhosted.org/packages/ed/ba/431d7f420cd93c4b8ccb15ed8f1c6c76c81965634fd70345af0b19c2b7bc/plumbum-1.7.0.tar.gz"
    sha256 "317744342c755319907c773cc87c3a30adaa3a41b0d34c0ce02d9d1904922dce"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/b9/d2/12a808613937a6b98cd50d6467352f01322dc0d8ca9fb5b94441625d6684/pydantic-1.8.2.tar.gz"
    sha256 "26464e57ccaafe72b7ad156fdaa4e9b9ef051f69e175dbbb463283000c05ab7b"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/69/42/aa0fa900c3a5f142098e1b013995e92c2f31e1de68042cb95fa4a022bb8a/pyparsing-3.0.0.tar.gz"
    sha256 "001cad8d467e7a9248ef9fd513f5c0d39afcbcb9a43684101853bd0ab962e479"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "pyyaml-include" do
    url "https://files.pythonhosted.org/packages/c2/c4/a2500ded8d2ba93e060ada38cefe750aa4604cdf40417c90ac870f4da0a5/pyyaml-include-1.2.post2.tar.gz"
    sha256 "60047fc0a186debb9c80b3c3a23ef73b0096f6ee4ab2124b29d642c3fea0aebe"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/2e/e4/3447fed9ab29944333f48730ecff4dca92f0868c5b188d6ab2b2078e32c2/regex-2020.11.13.tar.gz"
    sha256 "83d6b356e116ca119db8e7c6fc2983289d87b27b3fac238cfe5dca529d884562"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/ed/12/c5079a15cf5c01d7f4252b473b00f7e68ee711be605b9f001528f0298b98/typing_extensions-3.10.0.2.tar.gz"
    sha256 "49f75d16ff11f1cd258e1b988ccff82a3ca5570217d7ad8c5f48205dd99a677e"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources
    system Formula["poetry"].opt_bin/"poetry", "build", "--format", "wheel", "--verbose", "--no-interaction"
    venv.pip_install_and_link Dir["dist/copier-*.whl"].first
  end

  test do
    params = %w[
      -d python=true
      -d js=true
      -d ansible=false
      -d biggest_kbs=1000
      -d main_branches=null
      -d github=true
    ]
    system bin/"copier", *params, "--vcs-ref=v0.1.0", "https://github.com/copier-org/autopretty.git", "template"
    assert (testpath/"template").directory?
    assert_predicate testpath/"template/.copier-answers.autopretty.yml", :exist?
  end
end
