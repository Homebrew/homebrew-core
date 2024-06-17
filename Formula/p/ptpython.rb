class Ptpython < Formula
  include Language::Python::Virtualenv

  desc "Advanced Python REPL"
  homepage "https://github.com/prompt-toolkit/ptpython"
  url "https://files.pythonhosted.org/packages/61/8c/cd6f18bbd33bc83c628124fbbf61ce348e64523ec62fdce28e1b9d8a9a1c/ptpython-3.0.27.tar.gz"
  sha256 "24b0fda94b73d1c99a27e6fd0d08be6f2e7cda79a2db995c7e3c7b8b1254bad9"
  license "BSD-3-Clause"
  head "https://github.com/prompt-toolkit/ptpython.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a282e45c8e20f1feb5d66673234135475c0195c17e46ace33df8e52c43729d33"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a282e45c8e20f1feb5d66673234135475c0195c17e46ace33df8e52c43729d33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a282e45c8e20f1feb5d66673234135475c0195c17e46ace33df8e52c43729d33"
    sha256 cellar: :any_skip_relocation, sonoma:         "45c7ebca632778d04e1c4fd67937561ea3c3b301de2650de3e15228986aeefca"
    sha256 cellar: :any_skip_relocation, ventura:        "45c7ebca632778d04e1c4fd67937561ea3c3b301de2650de3e15228986aeefca"
    sha256 cellar: :any_skip_relocation, monterey:       "45c7ebca632778d04e1c4fd67937561ea3c3b301de2650de3e15228986aeefca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e56a3092044442fcfbba2284068a09f4690ac65f62a5a10c944c313ca3b192f"
  end

  depends_on "python@3.12"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/d6/99/99b493cec4bf43176b678de30f81ed003fd6a647a301b9c927280c600f0a/jedi-0.19.1.tar.gz"
    sha256 "cf0496f3651bc65d7174ac1b7d043eff454892c708a87d1b683e57b569927ffd"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/66/94/68e2e17afaa9169cf6412ab0f28623903be73d1b32e208d9e8e541bb086d/parso-0.8.4.tar.gz"
    sha256 "eb3a7b58240fb99099a345571deecc0f9540ea5f4dd2fe14c2a99d6b281ab92d"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/d5/88/869b717061b03b0025a3df923516cf999366954c0f0f8e13facd9dd166fa/prompt_toolkit-3.0.44.tar.gz"
    sha256 "c1dfd082c4259964bc8bcce1f8460d9dbeb5d4a37bfc25b8082bc02cd41c8af6"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write "print(2+2)\n"
    assert_equal "4", shell_output("#{bin}/ptpython test.py").chomp
  end
end
