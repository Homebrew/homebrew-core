class Coala < Formula
  include Language::Python::Virtualenv

  desc "provides a command-line interface for linting and fixing all your code."
  homepage "http://coala.io/"
  url "https://github.com/coala/coala/archive/0.8.1.tar.gz"
  sha256 "23ece17d2ba0adc147f60b570960a06fe70eef465dead4e1fc95e81e3a8071c1"
  head "https://github.com/coala/coala.git"

  depends_on :python3

  resource "appdirs" do
    url "https://pypi.python.org/packages/bd/66/0a7f48a0f3fb1d3a4072bceb5bbd78b1a6de4d801fb7135578e7c7b1f563/appdirs-1.4.0.tar.gz"
    sha256 "8fc245efb4387a4e3e0ac8ebcc704582df7d72ff6a42a53f5600bbb18fdaadc5"
  end
  
  resource "PyPrint" do
    url "https://pypi.python.org/packages/db/cc/48f0a5f53d4bdbadc4322650c44e44d6901f81b64dfe07f706fbebbfaeef/PyPrint-0.2.5.tar.gz"
    sha256 "57996f1ec09271d9a43b2ea5187f630ac1aa06195bede66c1915dcfaf9742ce9"
  end
  
  resource "termcolor" do
    url "https://pypi.python.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end
  
  resource "colorama" do
    url "https://pypi.python.org/packages/f0/d0/21c6449df0ca9da74859edc40208b3a57df9aca7323118c913e58d442030/colorama-0.3.7.tar.gz"
    sha256 "e043c8d32527607223652021ff648fbb394d5e19cba9f1a698670b338c9d782b"
  end
  
  resource "Pygments" do
    url "https://pypi.python.org/packages/b8/67/ab177979be1c81bc99c8d0592ef22d547e70bb4c6815c383286ed5dec504/Pygments-2.1.3.tar.gz"
    sha256 "88e4c8a91b2af5962bfa5ea2447ec6dd357018e86e94c7d14bd8cacbc5b55d81"
  end
  
  resource "setuptools" do
    url "https://pypi.python.org/packages/25/4e/1b16cfe90856235a13872a6641278c862e4143887d11a12ac4905081197f/setuptools-28.8.0.tar.gz"
    sha256 "432a1ad4044338c34c2d09b0ff75d509b9849df8cf329f4c1c7706d9c2ba3c61"
  end
  
  resource "libclang-py3" do
    url "https://pypi.python.org/packages/ce/f0/2e94b6776f993c4a59ac7e15e34a276413832fe2328d00e2324b26b0dd02/libclang-py3-0.2.tar.gz"
    sha256 "24e1eb495bf8774ef5f91f077388bb5b83c891207171c954a34e225aedd04d28"
  end
  
  resource "coala_utils" do
    url "https://pypi.python.org/packages/fa/98/bfd3f70677af89f9b8cfb26ccfc5beb41b811e8ce9354f5e1d1e41c86258/coala_utils-0.4.10.tar.gz"
    sha256 "25c1e9b97d166e27e17a1f521a689ceb7c5e363a42f3a7de4ece70a8d05fd686"
  end
  
  resource "colorlog" do
    url "https://pypi.python.org/packages/95/59/c70e535f1b3b8eab2279dc58dc5ce1a780eb83efccefa55ca745dc7f02ee/colorlog-2.7.0.tar.gz"
    sha256 "8e197dae35398049965293021dd69a9db068efe97133597f128e5ef69392f33e"
  end
  
  def install
    virtualenv_install_with_resources
  end

  test do
    script = "import coalib"
    system libexec/"bin/python", "-c", script
  end
end
