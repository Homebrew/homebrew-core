class Dnsviz < Formula
  include Language::Python::Virtualenv

  desc "Tools for analyzing and visualizing DNS and DNSSEC behavior"
  homepage "https://github.com/dnsviz/dnsviz/"
  url "https://files.pythonhosted.org/packages/59/91/aa152739fea36d4456fbcc71a26333ffef587526d722c10c281ab12a6a35/dnsviz-0.11.1.tar.gz"
  sha256 "203b1aa2e3aa09af415a96a0afc98eef4acf845ab8af57bf9f7569bd13161717"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "58f6246102424efbe090d5d19a9ee66094d9b6794cc12d4c321e093171558cfc"
    sha256 cellar: :any,                 arm64_sequoia: "4a27473e4697572460d0e073612a19627a6d5d8bb374989d9c894ff1ee144fe6"
    sha256 cellar: :any,                 arm64_sonoma:  "66c3394a50ef771c0b3a1ffbd559a89f98b9d8d10dee5d91a9e9e68c5a0c34e7"
    sha256 cellar: :any,                 sonoma:        "7fdd639b7c9e6c9357bac4dcc167fad445a2d57a594b0429e8937d28a97bad1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4170e714f3e6b25e6e21016ab510bab81d34165aa4942c1db79f9e254bcd3fc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b30d7527b2c27dd84a700afffc2ea95bf978164453e96a48be58bd1d1e10fd9"
  end

  depends_on "bind" => [:build, :test]
  depends_on "pkgconf" => :build
  depends_on "swig" => :build
  depends_on "json-c" => :test
  depends_on "cryptography" => :no_linkage
  depends_on "graphviz"
  depends_on "openssl@3"
  depends_on "python@3.14"

  pypi_packages extra_packages: ["dnspython", "pygraphviz"]

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
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
