class Djlint < Formula
  include Language::Python::Virtualenv

  desc "Lint & Format HTML Templates"
  homepage "https://djlint.com"
  url "https://files.pythonhosted.org/packages/74/89/ecf5be9f5c59a0c53bcaa29671742c5e269cc7d0e2622e3f65f41df251bf/djlint-1.36.4.tar.gz"
  sha256 "17254f218b46fe5a714b224c85074c099bcb74e3b2e1f15c2ddc2cf415a408a1"
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
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
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
    url "https://files.pythonhosted.org/packages/12/ae/929aee9619e9eba9015207a9d2c1c54db18311da7eb4dcf6d41ad6f0eb67/json5-0.12.1.tar.gz"
    sha256 "b2743e77b3242f8d03c143dd975a6ec7c52e2f2afe76ed934e53503dd4ad4990"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/49/d3/eaa0d28aba6ad1827ad1e716d9a93e1ba963ada61887498297d3da715133/regex-2025.9.18.tar.gz"
    sha256 "c5ba23274c61c6fef447ba6a39333297d0c247f53059dba0bca415cac511edc4"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
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
