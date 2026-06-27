class Djlint < Formula
  include Language::Python::Virtualenv

  desc "Lint & Format HTML Templates"
  homepage "https://djlint.com"
  url "https://files.pythonhosted.org/packages/63/6b/db4829f972157ef45a04563f3360d1bd6425c040c4cb488646755bbc1387/djlint-1.39.4.tar.gz"
  sha256 "e9ea9b4558785a1193268ad06ac5766647613b3733c00fda5c20a479e031bdbd"
  license "GPL-3.0-or-later"
  head "https://github.com/djlint/djLint.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fd20ddf0b99432aa28baecb54b2ca642c78f76c1e3c8b66db457a6000aa26042"
    sha256 cellar: :any, arm64_sequoia: "1208fe6a50ffb68ecb869ed23493faf06074876b324948abcb24040e50a84c14"
    sha256 cellar: :any, arm64_sonoma:  "d212d5a02ed0914d81419aaeca1db98a51f78ec03470fa71ab893c2a908c1c90"
    sha256 cellar: :any, sonoma:        "d88764e8c4beddb75a5929c7e388e4b9b5e77433ad5bcc93767ecc47ee6ec69d"
    sha256 cellar: :any, arm64_linux:   "c5ac3e572729c834adefb3c9801f40acaafa4dddcd6cfbcec493fdf4d8eff45e"
    sha256 cellar: :any, x86_64_linux:  "bbc7a60b56b88013ac8ebcafa2364bebb07a3d15cd957967412c16157099ae68"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "click" do
    url "https://files.pythonhosted.org/packages/9b/98/518d8e5081007684232226f475082b30087d0f585e8457db087298259f49/click-8.4.1.tar.gz"
    sha256 "918b5633eddf6b41c32d4f454bf0de810065c74e3f7dbf8ee5452f8be88d3e96"
  end

  resource "cssbeautifier" do
    url "https://files.pythonhosted.org/packages/7b/dc/05e09a3cdacaeb73350442dfef37b9e22f764a076636df70e6d4c779c2a9/cssbeautifier-2.0.1.tar.gz"
    sha256 "f6102c0589c85be3c1a016cee76ee3661ee4bd5da88d48a5f8708bfaf663ae26"
  end

  resource "editorconfig" do
    url "https://files.pythonhosted.org/packages/88/3a/a61d9a1f319a186b05d14df17daea42fcddea63c213bcd61a929fb3a6796/editorconfig-0.17.1.tar.gz"
    sha256 "23c08b00e8e08cc3adcddb825251c497478df1dada6aefeb01e626ad37303745"
  end

  resource "jsbeautifier" do
    url "https://files.pythonhosted.org/packages/48/a4/6283089b46c2bd895f5c4b223456167ea859ce54fed01f4c1ee4e8a8ed20/jsbeautifier-2.0.1.tar.gz"
    sha256 "45603b2097410feee8d3a6ef8ad5a8e0a0e89f347331888a97e46f332ce8d953"
  end

  resource "json5" do
    url "https://files.pythonhosted.org/packages/e4/7d/05c46a96a78147ae3bf99c2f4169ce144a70220b8d6fcd56f6ec368b8ce9/json5-0.15.0.tar.gz"
    sha256 "7424d1f1eb1d56da6e3d70643f53619862b4ce81440bdb8ecfd6f875e5ba4a71"
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

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"djlint", shell_parameter_format: :click)
  end

  test do
    assert_includes shell_output("#{bin}/djlint --version"), version.to_s

    (testpath/"test.html").write <<~HTML
      {% load static %}<!DOCTYPE html>
    HTML

    output = shell_output("#{bin}/djlint --reformat --no-github-output #{testpath}/test.html", 1)
    assert_match "1 file was updated.", output
  end
end
