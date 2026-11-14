class Djlint < Formula
  include Language::Python::Virtualenv

  desc "Lint & Format HTML Templates"
  homepage "https://djlint.com"
  url "https://files.pythonhosted.org/packages/5d/e2/8eb9b60727ae636d9ac76e6868061f0663d4b1e3737918e4e109c33e2d6f/djlint-1.50.0.tar.gz"
  sha256 "ff6bc81d27f89c5776420295fe3c671ba496a5bdc7bf3b5c46e10ee95a99bed5"
  license "GPL-3.0-or-later"
  head "https://github.com/djlint/djLint.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4a0e29a8602958f46a7a4effecfa70b1b77ff0b0d8f1327de3096b12896419f4"
    sha256 cellar: :any, arm64_tahoe:       "589d2ad281653ca61de65456e01252c2c0c56495b7dd64f2587868447114e512"
    sha256 cellar: :any, arm64_sequoia:     "017ec1085995d5733751cd0a6c78bf41127c4aa4a02784eda18e62328c71c759"
    sha256 cellar: :any, arm64_linux:       "36536bef50d337e490d6b97033fc157afcb4b0c2bcdce72e7a1c794f2bdf37c6"
    sha256 cellar: :any, x86_64_linux:      "37b4e00716928d607d7104f59910958f49e94acc5330a6319620e4088964769e"
  end

  depends_on "libyaml"
  depends_on "python@3.15"

  resource "click" do
    url "https://files.pythonhosted.org/packages/45/37/edbf1b0707709013c0cf2e8317e03d97ed29bf4cac709fe328904ae92a38/click-8.5.1.tar.gz"
    sha256 "9bbfada76703fd1d784b83eea012e3e8c6a001a876543ef104fa56aaaeb072b4"
  end

  resource "cssbeautifier" do
    url "https://files.pythonhosted.org/packages/8f/b2/ed2890f0862fea7b79bb5224e22b2393376fdcd8f4b4e24dbbf1e9256d23/cssbeautifier-2.0.3.tar.gz"
    sha256 "2c2fd129342561029de86b1744efa231c9fafe26023dbc988a1deb0ca0f5c845"
  end

  resource "editorconfig" do
    url "https://files.pythonhosted.org/packages/88/3a/a61d9a1f319a186b05d14df17daea42fcddea63c213bcd61a929fb3a6796/editorconfig-0.17.1.tar.gz"
    sha256 "23c08b00e8e08cc3adcddb825251c497478df1dada6aefeb01e626ad37303745"
  end

  resource "jsbeautifier" do
    url "https://files.pythonhosted.org/packages/2e/81/e0e11e305caa89831a0c8e555638d588c28b426d1105e734e113b00efd5d/jsbeautifier-2.0.3.tar.gz"
    sha256 "9579d4e9dbaa00383f3efdff4c98c8140bb85ba319398e8b97cdaba27abd6ba3"
  end

  resource "json5" do
    url "https://files.pythonhosted.org/packages/16/1f/58a4d7ee466f81bc3c7337036380fc6d49de3afb7855d74f8121b1e89b32/json5-0.17.3.tar.gz"
    sha256 "8d0278ad34ebaa9c3af76d9519274811830224a2d1cd5af156dbd067f461b8a4"
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
    url "https://files.pythonhosted.org/packages/61/27/a5afeb952577b84ee5fe48b8b9ce47ae662dbb69cc5b76c28eff98f83b1e/regex-2026.11.9.tar.gz"
    sha256 "316a70fbd70e999c9664681cb0eb5b4982b2cc0f623c7c86a8a112e1bd4c6277"
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
