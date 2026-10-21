class Fusesoc < Formula
  include Language::Python::Virtualenv

  desc "Package manager and build abstraction tool for HDL code"
  homepage "https://fusesoc.net"
  url "https://files.pythonhosted.org/packages/3c/58/639a43653bbd97d1fa75255b57a224755c775df54b568fb714651530e104/fusesoc-2.4.7.tar.gz"
  sha256 "f1023de57524660b5926fec6807af0edecb04418918e39a15224c83855546894"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "21e1974d9c485bba09fd438522d1d8694c746d3a43ac8a3c5ddf60772c5ea0ca"
    sha256 cellar: :any, arm64_tahoe:       "702b90d2325ecf4039100792e6fc0e1a0084a7a6bf0ac180360c4b6c951d126e"
    sha256 cellar: :any, arm64_sequoia:     "ac4347a287d12695ab54e71ae535d4c2ad78fc9a8dc888e9be9e40abf6954819"
    sha256 cellar: :any, arm64_linux:       "1fc25a6fe00771966116a15f061b51adb8e50edd05afb9518452c14948c83023"
    sha256 cellar: :any, x86_64_linux:      "6970c07dd67eccdaf9bbf86dc9e64cffac6a90f47d64d2d5746e15dd98e336b8"
  end

  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"

  pypi_packages exclude_packages: "pydantic"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "edalize" do
    url "https://files.pythonhosted.org/packages/5e/77/e7b0f6b96c6eafdb798a8b7a4c76c064522d94aecb7fc0ea442ff7d6291b/edalize-0.6.8.tar.gz"
    sha256 "d1d2b9d441789c718e7480c9c4ce55fd39b463f2a7f0f328da1daed7179b1e72"
  end

  resource "fastjsonschema" do
    url "https://files.pythonhosted.org/packages/33/a4/9473c7c3b87009d9c1d74034e4a0f6a35ff0d42dd0f9866d0c3ec4e9217b/fastjsonschema-2.22.2.tar.gz"
    sha256 "72064e12356a7d6ef02165be2946b9abadbdf238536e07eb587e3dbaa33099cf"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "okonomiyaki" do
    url "https://files.pythonhosted.org/packages/f2/95/2a3cde9beff788a9ec34d64525e509e3ae4d4053669ae1be30a000fdee5b/okonomiyaki-3.0.0.tar.gz"
    sha256 "f5de606542d27821fda1a59c4e13dfa9adf227a0e4dc28a408e280918b54b70e"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/e4/11/b213bebff182584360cb8d17c72c1677fec5c5c228de439e63bcf8ab1c8f/pyparsing-3.3.3.tar.gz"
    sha256 "928ae7e20211f3b6f3915a72f06a0cfd29ab9d24279dd6346b6b1a7146397d36"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "simplesat" do
    url "https://files.pythonhosted.org/packages/24/60/9c4a2534ae17dc5397c0536c3875a6ea8acf5d65f099ae617ce676433f3b/simplesat-0.9.2.tar.gz"
    sha256 "8cb800d09289bdc051126e725949368f8ac25105d40865cb93aa20eae9d46a9c"

    # Fix import on Python 3.15
    patch do
      url "https://github.com/enthought/sat-solver/commit/cae79b0c938fc796c37474221e53b6e4fde87d30.patch?full_index=1"
      sha256 "743079f81396d73fbdcd3eef97a9fbfd53f9a187cddd1d81e11d590fa6ad979a"
      type :unofficial
      resolves "https://github.com/enthought/sat-solver/pull/305"
    end
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fusesoc --version")

    (testpath/"homebrew-test.core").write <<~EOS
      CAPI=2:
      name: ::homebrew-test:1.0.0
      description: Homebrew test core
    EOS
    system bin/"fusesoc", "library", "add", "."
    assert_match "::homebrew-test:1.0.0", shell_output("#{bin}/fusesoc core list")
  end
end
