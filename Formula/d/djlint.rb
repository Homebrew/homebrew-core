class Djlint < Formula
  include Language::Python::Virtualenv

  desc "Lint & Format HTML Templates"
  homepage "https://djlint.com"
  url "https://files.pythonhosted.org/packages/1a/15/68bd27155429217a94a168fc31b50622dee2558412576a5c457e8cf4799b/djlint-1.38.0.tar.gz"
  sha256 "caec391b07fe440a2cbdc2ea9fcad5b3eede9a01043958d38fb511cbefa3a525"
  license "GPL-3.0-or-later"
  head "https://github.com/djlint/djLint.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:   "e6fbe8ed33b18abe793b3823d3e3083f5dda9ae9f3a9810b56ea0cc7eb1a1f23"
    sha256 cellar: :any,                 arm64_sequoia: "aebbbb58314eafe8c5562435a6c35486ee26d1b5dc322e63b9b9c890a9a5b923"
    sha256 cellar: :any,                 arm64_sonoma:  "15447c3b978c0469538bcbff9ec6773d1ba938bd97af4193ce20be14d1e534af"
    sha256 cellar: :any,                 sonoma:        "8170ce4af546527c8648c0bb50f2c97445ae013039291719983c6c1d2af76dd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a09e6acccfa498e1cdd6fc1738930cccca64e73ab1f69e0e93d438f40ef872e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f98b311ebc255c06faadad504a390f7618a4b817305c7d1a8275281bfe84a833"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "click" do
    url "https://files.pythonhosted.org/packages/9b/98/518d8e5081007684232226f475082b30087d0f585e8457db087298259f49/click-8.4.1.tar.gz"
    sha256 "918b5633eddf6b41c32d4f454bf0de810065c74e3f7dbf8ee5452f8be88d3e96"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "cssbeautifier" do
    url "https://files.pythonhosted.org/packages/f7/01/fdf41c1e5f93d359681976ba10410a04b299d248e28ecce1d4e88588dde4/cssbeautifier-1.15.4.tar.gz"
    sha256 "9bb08dc3f64c101a01677f128acf01905914cf406baf87434dcde05b74c0acf5"
  end

  resource "editorconfig" do
    url "https://files.pythonhosted.org/packages/88/3a/a61d9a1f319a186b05d14df17daea42fcddea63c213bcd61a929fb3a6796/editorconfig-0.17.1.tar.gz"
    sha256 "23c08b00e8e08cc3adcddb825251c497478df1dada6aefeb01e626ad37303745"
  end

  resource "jsbeautifier" do
    url "https://files.pythonhosted.org/packages/ea/98/d6cadf4d5a1c03b2136837a435682418c29fdeb66be137128544cecc5b7a/jsbeautifier-1.15.4.tar.gz"
    sha256 "5bb18d9efb9331d825735fbc5360ee8f1aac5e52780042803943aa7f854f7592"
  end

  resource "json5" do
    url "https://files.pythonhosted.org/packages/9c/4b/6f8906aaf67d501e259b0adab4d312945bb7211e8b8d4dcc77c92320edaa/json5-0.14.0.tar.gz"
    sha256 "b3f492fad9f6cdbced8b7d40b28b9b1c9701c5f561bef0d33b81c2ff433fefcb"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/dc/0e/49aee608ad09480e7fd276898c99ec6192985fa331abe4eb3a986094490b/regex-2026.5.9.tar.gz"
    sha256 "a8234aa23ec39894bfe4a3f1b85616a7032481964a13ac6fc9f10de4f6fca270"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/09/a9/6ba95a270c6f1fbcd8dac228323f2777d886cb206987444e4bce66338dd4/tqdm-4.67.3.tar.gz"
    sha256 "7d825f03f89244ef73f1d4ce193cb1774a8179fd96f31d7e1dcde62092b960bb"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"djlint", shell_parameter_format: :click)
  end

  test do
    assert_includes shell_output("#{bin}/djlint --version"), version.to_s

    (testpath/"test.html").write <<~HTML
      {% load static %}<!DOCTYPE html>
    HTML

    assert_includes shell_output("#{bin}/djlint --reformat #{testpath}/test.html", 1), "1 file was updated."
  end
end
