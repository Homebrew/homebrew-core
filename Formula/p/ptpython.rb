class Ptpython < Formula
  include Language::Python::Virtualenv

  desc "Advanced Python REPL"
  homepage "https://github.com/prompt-toolkit/ptpython"
  url "https://files.pythonhosted.org/packages/56/61/352792c9f47de98a910526ff8a684466a6217e53ffa6627b3781960e4f0d/ptpython-3.0.29.tar.gz"
  sha256 "b9d625183aef93a673fc32cbe1c1fcaf51412e7a4f19590521cdaccadf25186e"
  license "BSD-3-Clause"
  head "https://github.com/prompt-toolkit/ptpython.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "969a5aa84d7dcf9d003bcf774cf1561867d624b5cf7d73dba6219f9300e22122"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "969a5aa84d7dcf9d003bcf774cf1561867d624b5cf7d73dba6219f9300e22122"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "969a5aa84d7dcf9d003bcf774cf1561867d624b5cf7d73dba6219f9300e22122"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ae059b9b30acb2b7136ee06ce89c37a5035b0d2709caf553c75f73582d2ab74"
    sha256 cellar: :any_skip_relocation, ventura:        "3ae059b9b30acb2b7136ee06ce89c37a5035b0d2709caf553c75f73582d2ab74"
    sha256 cellar: :any_skip_relocation, monterey:       "3ae059b9b30acb2b7136ee06ce89c37a5035b0d2709caf553c75f73582d2ab74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29922808046c45096717d09e2a59f171c1d90a24ff77e812a2fa0b63f05b0723"
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
    url "https://files.pythonhosted.org/packages/47/6d/0279b119dafc74c1220420028d490c4399b790fc1256998666e3a341879f/prompt_toolkit-3.0.47.tar.gz"
    sha256 "1e1b29cb58080b1e69f207c893a1a7bf16d127a5c30c9d17a25a5d77792e5360"
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
