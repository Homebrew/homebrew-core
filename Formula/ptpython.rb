class Ptpython < Formula
  include Language::Python::Virtualenv

  desc "Advanced Python REPL"
  homepage "https://github.com/prompt-toolkit/ptpython"
  url "https://files.pythonhosted.org/packages/d5/95/1acee8aec7a8a683c03ced796217713aa649e370b621308f9c5e164124e3/ptpython-3.0.21.tar.gz"
  sha256 "a57b9952eac4a12540a4dfb4ccd4a243403eceb27b0d13245b5e4144c8731d32"
  license "BSD-3-Clause"
  head "https://github.com/prompt-toolkit/ptpython.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc45a7a29722a71a40baae07edb163c7dd123f35ab63dd213f40be6d18d23293"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05cc373abe49122d27cba62ebb57c893c5b2576f5e5cec22a2d373351f37dc67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c25f4dfeebb3d42c72b45471e2da55bb8e0feeca9d3c0e1cb7b227e8e6b5ec8d"
    sha256 cellar: :any_skip_relocation, monterey:       "3f8f3eb07c8bcad3b755c4c6022124e8d8c42d21252fa38eb2571984d8ad3c2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "227e6d49b251ecd0ca473f9fd12b5d6b5dafa67db38274b8ced16e41980de282"
    sha256 cellar: :any_skip_relocation, catalina:       "a36aa79b5c45151126e8882341cccda04b830f648f1dc23bf1083823ac57b74c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b0912da9db6a512c7561329ec44329f710ddfb05cf41809b4ed93fcce20acd8"
  end

  depends_on "python@3.11"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/15/02/afd43c5066de05f6b3188f3aa74136a3289e6c30e7a45f351546cab0928c/jedi-0.18.2.tar.gz"
    sha256 "bae794c30d07f6d910d32a7048af09b5a39ed740918da923c6b780790ebac612"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/a2/0e/41f0cca4b85a6ea74d66d2226a7cda8e41206a624f5b330b958ef48e2e52/parso-0.8.3.tar.gz"
    sha256 "8c07be290bb59f03588915921e29e8a50002acaf2cdc5fa0e0114f91709fafa0"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/c4/6e/6ff7938f47981305a801a4c5b8d8ed282b58a28c01c394d43c1fbcfc810b/prompt_toolkit-3.0.33.tar.gz"
    sha256 "535c29c31216c77302877d5120aef6c94ff573748a5b5ca5b1b1f76f5e700c73"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/e0/ef/5905cd3642f2337d44143529c941cc3a02e5af16f0f65f81cbef7af452bb/Pygments-2.13.0.tar.gz"
    sha256 "56a8508ae95f98e2b9bdf93a6be5ae3f7d8af858b43e02c5a2ff083726be40c1"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write "print(2+2)\n"
    assert_equal "4", shell_output("#{bin}/ptpython test.py").chomp
  end
end
