class Ipython < Formula
  include Language::Python::Virtualenv

  desc "Interactive computing in Python"
  homepage "https://ipython.org/"
  url "https://files.pythonhosted.org/packages/29/e6/48c74d54039241a456add616464ea28c6ebf782e4110d419411b83dae06f/ipython-9.7.0.tar.gz"
  sha256 "5f6de88c905a566c6a9d6c400a8fed54a638e1f7543d17aae2551133216b1e4e"
  license "BSD-3-Clause"
  head "https://github.com/ipython/ipython.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "46c3a258b3382c3458244e01c08336e984fefea147cac87923400a4397bc5f9a"
  end

  depends_on "python@3.14"

  resource "asttokens" do
    url "https://files.pythonhosted.org/packages/4a/e7/82da0a03e7ba5141f05cce0d302e6eed121ae055e0456ca228bf693984bc/asttokens-3.0.0.tar.gz"
    sha256 "0dcd8baa8d62b0c1d118b399b2ddba3c4aff271d0d7a9e0d4c1681c79035bbc7"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/43/fa/6d96a0978d19e17b68d634497769987b16c8f4cd0a7a05048bec693caa6b/decorator-5.2.1.tar.gz"
    sha256 "65f266143752f734b0a7cc83c46f4618af75b8c5911b00ccb61d0ac9b6da0360"
  end

  resource "executing" do
    url "https://files.pythonhosted.org/packages/cc/28/c14e053b6762b1044f34a13aab6859bbf40456d37d23aa286ac24cfd9a5d/executing-2.2.1.tar.gz"
    sha256 "3632cc370565f6648cc328b32435bd120a1e4ebb20c77e3fdde9a13cd1e533c4"
  end

  resource "ipython-pygments-lexers" do
    url "https://files.pythonhosted.org/packages/ef/4c/5dd1d8af08107f88c7f741ead7a40854b8ac24ddf9ae850afbcf698aa552/ipython_pygments_lexers-1.1.1.tar.gz"
    sha256 "09c0138009e56b6854f9535736f4171d855c8c08a563a0dcd8022f78355c7e81"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/72/3a/79a912fbd4d8dd6fbb02bf69afd3bb72cf0c729bb3063c6f4498603db17a/jedi-0.19.2.tar.gz"
    sha256 "4770dc3de41bde3966b02eb84fbcf557fb33cce26ad23da12c742fb50ecb11f0"
  end

  resource "matplotlib-inline" do
    url "https://files.pythonhosted.org/packages/c7/74/97e72a36efd4ae2bccb3463284300f8953f199b5ffbc04cbbb0ec78f74b1/matplotlib_inline-0.2.1.tar.gz"
    sha256 "e1ee949c340d771fc39e241ea75683deb94762c8fa5f2927ec57c83c4dffa9fe"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/d4/de/53e0bcf53d13e005bd8c92e7855142494f41171b34c2536b86187474184d/parso-0.8.5.tar.gz"
    sha256 "034d7354a9a018bdce352f48b2a8a450f05e9d6ee85db84764e9b6bd96dafe5a"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/42/92/cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149d/pexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pure-eval" do
    url "https://files.pythonhosted.org/packages/cd/05/0a34433a064256a578f1783a10da6df098ceaa4a57bbeaa96a6c0352786b/pure_eval-0.2.3.tar.gz"
    sha256 "5f4e983f40564c576c7c8635ae88db5956bb2229d7e9237d03b3c0b0190eaf42"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "stack-data" do
    url "https://files.pythonhosted.org/packages/28/e3/55dcc2cfbc3ca9c29519eb6884dd1415ecb53b0e934862d3559ddcb7e20b/stack_data-0.6.3.tar.gz"
    sha256 "836a778de4fec4dcd1dcd89ed8abff8a221f58308462e1c4aa2a3cf30148f0b9"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/eb/79/72064e6a701c2183016abbbfedaba506d81e30e232a68c9f0d6f6fcd1574/traitlets-5.14.3.tar.gz"
    sha256 "9ed0579d3502c94b4b3732ac120375cda96f923114522847de4b3bb98b96b6b7"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
  end

  def install
    venv = virtualenv_install_with_resources

    # Build an `:all` bottle
    inreplace venv.site_packages/"IPython/core/application.py", "/usr/local", HOMEBREW_PREFIX
  end

  test do
    assert_equal "4", shell_output("#{bin}/ipython -c 'print(2+2)'").chomp
  end
end
