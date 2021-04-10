class Mk < Formula
  include Language::Python::Virtualenv

  desc "Developer friendly build/test CLI launcher"
  homepage "https://github.com/pycontribs/mk"
  url "https://files.pythonhosted.org/packages/fe/cd/fe07815319409d39c7b7506e865708caa289a82126f683b63c2e51ff3428/mk-1.0.2.tar.gz"
  sha256 "6637f035ddf92a43d2daa5264ce3bfbb5c7e937a3967a1618e48f7247a6914d0"
  license "MIT"

  depends_on "python@3.9" => :build

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "blessings" do
    url "https://files.pythonhosted.org/packages/5c/f8/9f5e69a63a9243448350b44c87fae74588aa634979e6c0c501f26a4f6df7/blessings-1.7.tar.gz"
    sha256 "98e5854d805f50a5b58ac2333411b0482516a8210f23f43308baeb58d77c157d"
  end
  resource "click-help-colors" do
    url "https://files.pythonhosted.org/packages/f2/bc/59845c80c99d77321c3271a941b616cbdfd7a3602647532150d14e95e93d/click-help-colors-0.9.tar.gz"
    sha256 "eb037a2dd95a9e20b3897c2b3ca57e7f6797f76a8d93f7eeedda7fcdcbc9b635"
  end
  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end
  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end
  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end
  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/34/fe/9265459642ab6e29afe734479f94385870e8702e7f892270ed6e52dd15bf/gitdb-4.0.7.tar.gz"
    sha256 "96bf5c08b157a666fec41129e6d327235284cca4c81e92109260f353ba138005"
  end
  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/5f/f2/ea3242d97695451ab1521775a85253e002942d2c8f4519ae1172c0f5f979/GitPython-3.1.14.tar.gz"
    sha256 "be27633e7509e58391f10207cd32b2a6cf5b908f92d9cd30da2e514e1137af61"
  end
  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f8/04/7a8542bed4b16a65c2714bf76cf5a0b026157da7f75e87cc88774aa10b14/pluggy-0.13.1.tar.gz"
    sha256 "15b2acde666561e1298d71b523007ed7364de07029219b604cf808bfa1c765b0"
  end
  resource "pygments" do
    url "https://files.pythonhosted.org/packages/15/9d/bc9047ca1eee944cc245f3649feea6eecde3f38011ee9b8a6a64fb7088cd/Pygments-2.8.1.tar.gz"
    sha256 "2656e1a6edcdabf4275f9a3640db59fd5de107d88e8663c5d4e9a0fa62f77f94"
  end
  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end
  resource "rich" do
    url "https://files.pythonhosted.org/packages/12/3c/e4e2b356057f3ce557fcda8a2b9bf114b06f71ade88dac8a0883ae800e28/rich-10.1.0.tar.gz"
    sha256 "8f05431091601888c50341697cfc421dc398ce37b12bca0237388ef9c7e2c9e9"
  end
  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/9c/c9/a3e3bc667c8372a74aa4b16649c3466364cd84f7aacb73453c51b0c2c8a7/shellingham-1.4.0.tar.gz"
    sha256 "4855c2458d6904829bd34c299f11fdeed7cfefbf8a2c522e4caea6cd76b3171e"
  end
  resource "smmap" do
    url "https://files.pythonhosted.org/packages/dd/d4/2b4f196171674109f0fbb3951b8beab06cd0453c1b247ec0c4556d06648d/smmap-4.0.0.tar.gz"
    sha256 "7e65386bd122d45405ddf795637b7f7d2b532e7e401d46bbe3fb49b9986d5182"
  end
  resource "typer" do
    url "https://files.pythonhosted.org/packages/d5/74/40abdad73bc8b5b17a5a6e442fc57b20f5cc2ee869632625083762490de6/typer-0.3.2.tar.gz"
    sha256 "5455d750122cff96745b0dec87368f56d023725a7ebc9d2e54dd23dc86816303"
  end
  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/16/06/0f7367eafb692f73158e5c5cbca1aec798cdf78be5167f6415dd4205fa32/typing_extensions-3.7.4.3.tar.gz"
    sha256 "99d4073b617d30288f569d3f13d2bd7548c3a7e4c8de87db09a9d29bb3a4a60c"
  end
  resource "zipp" do
    url "https://files.pythonhosted.org/packages/38/f9/4fa6df2753ded1bcc1ce2fdd8046f78bd240ff7647f5c9bcf547c0df77e3/zipp-3.4.1.tar.gz"
    sha256 "3607921face881ba3e026887d8150cca609d517579abe052ac81fc5aeffdbd76"
  end
  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/8e/33/d54eacc679af34dc7c03fe9f3383669095b27fa17bd820cd33ec957cb249/importlib_metadata-3.10.0.tar.gz"
    sha256 "c9db46394197244adf2f0b08ec5bc3cf16757e9590b02af1fca085c16c0d600a"
  end

  def install
    virtualenv_install_with_resources(using: "python@3.9")
  end

  test do
    system "mk", "--version"
  end
end
