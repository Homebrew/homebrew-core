class Ptpython < Formula
  include Language::Python::Virtualenv

  desc "Advanced Python REPL"
  homepage "https://github.com/prompt-toolkit/ptpython"
  url "https://files.pythonhosted.org/packages/56/61/352792c9f47de98a910526ff8a684466a6217e53ffa6627b3781960e4f0d/ptpython-3.0.29.tar.gz"
  sha256 "b9d625183aef93a673fc32cbe1c1fcaf51412e7a4f19590521cdaccadf25186e"
  license "BSD-3-Clause"
  head "https://github.com/prompt-toolkit/ptpython.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf849fcfd4cf3ad93fbff7b5571fb08031728ec98670d3991b42328e79491309"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf849fcfd4cf3ad93fbff7b5571fb08031728ec98670d3991b42328e79491309"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf849fcfd4cf3ad93fbff7b5571fb08031728ec98670d3991b42328e79491309"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b9a05a2d93a6850a362423fbfde96e959b2573609a47a8d80f544e8124443cd"
    sha256 cellar: :any_skip_relocation, ventura:       "8b9a05a2d93a6850a362423fbfde96e959b2573609a47a8d80f544e8124443cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf849fcfd4cf3ad93fbff7b5571fb08031728ec98670d3991b42328e79491309"
  end

  depends_on "python@3.13"

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
    url "https://files.pythonhosted.org/packages/2d/4f/feb5e137aff82f7c7f3248267b97451da3644f6cdc218edfe549fb354127/prompt_toolkit-3.0.48.tar.gz"
    sha256 "d6623ab0477a80df74e646bdbc93621143f5caf104206aa29294d53de1a03d90"
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
