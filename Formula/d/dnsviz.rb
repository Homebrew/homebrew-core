class Dnsviz < Formula
  include Language::Python::Virtualenv

  desc "Tools for analyzing and visualizing DNS and DNSSEC behavior"
  homepage "https://github.com/dnsviz/dnsviz/"
  url "https://files.pythonhosted.org/packages/30/26/57a692b8f913ae22450f5b1dde5c52fe9a262c3e678eb63a4bdc0e464781/dnsviz-0.11.0.tar.gz"
  sha256 "3e93055950fc7837a40058f06190b0d9d7392332ea1aa0da6f9ff00c3b076d3e"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "7c45ee34909c224567abf12553318e640f7571a9bc180d7fa772efc915a5d2dc"
    sha256 cellar: :any,                 arm64_sonoma:  "2775217da4980d520e017a024d9f0640a5c3dd8d65c8f15134e18edb1d0823fb"
    sha256 cellar: :any,                 arm64_ventura: "658087f1a301001e35345cc79528fe8c990f0abc0d8b25fe11ee9bad935dc59f"
    sha256 cellar: :any,                 sonoma:        "95ab3f0f1a91635998ad85cbcd8f2324fea9c29559a201d7b00ed9ed7a0af5ae"
    sha256 cellar: :any,                 ventura:       "146eea3d7c4dfc1c96cdc0eed1011df849ab3ebfbb6833e0a6a76d43ea7dbbc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f1ed73bf2095d6d7527ed2be53ee8675011a45c96d34f01a4ece50a702604bd"
  end

  depends_on "bind" => [:build, :test]
  depends_on "pkgconf" => :build
  depends_on "swig" => :build
  depends_on "json-c" => :test
  depends_on "cryptography"
  depends_on "graphviz"
  depends_on "openssl@3"
  depends_on "python@3.13"

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/37/7d/c871f55054e403fdfd6b8f65fd6d1c4e147ed100d3e9f9ba1fe695403939/dnspython-2.6.1.tar.gz"
    sha256 "e8f0f9c23a7b7cb99ded64e6c3a6f3e701d78f50c55e002b839dea7225cff7cc"
  end

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/66/ca/823d5c74a73d6b8b08e1f5aea12468ef334f0732c65cbb18df2a7f285c87/pygraphviz-1.14.tar.gz"
    sha256 "c10df02377f4e39b00ae17c862f4ee7e5767317f1c6b2dfd04cea6acc7fc2bea"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "example-com-probe-auth" do
      url "https://raw.githubusercontent.com/dnsviz/dnsviz/refs/heads/master/tests/zones/unsigned/example.com-probe-auth.json"
      sha256 "6d75bf4e6289db41f8da6263aed2e0e8c910b8f303e4f065ec7d359997248997"
    end

    resource("example-com-probe-auth").stage do
      system bin/"dnsviz", "probe", "-d", "0",
        "-r", "example.com-probe-auth.json",
        "-o", "example.com.json"
      system bin/"dnsviz", "graph", "-r", "example.com.json", "-Thtml", "-o", File::NULL
      system bin/"dnsviz", "grok", "-r", "example.com.json", "-o", File::NULL
      system bin/"dnsviz", "print", "-r", "example.com.json", "-o", File::NULL
    end
  end
end
