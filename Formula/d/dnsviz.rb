class Dnsviz < Formula
  include Language::Python::Virtualenv

  desc "Tools for analyzing and visualizing DNS and DNSSEC behavior"
  homepage "https://github.com/dnsviz/dnsviz/"
  url "https://files.pythonhosted.org/packages/59/91/aa152739fea36d4456fbcc71a26333ffef587526d722c10c281ab12a6a35/dnsviz-0.11.1.tar.gz"
  sha256 "203b1aa2e3aa09af415a96a0afc98eef4acf845ab8af57bf9f7569bd13161717"
  license "GPL-2.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e57a56ddf9f4b9ea391a9a756be73f6325a4a3832560d4213ea12ebfb0b35cfe"
    sha256 cellar: :any, arm64_tahoe:       "44692d820713f8737f341ee25fbebe30587a47ecab58ed8e2399b27bbcf2f9a9"
    sha256 cellar: :any, arm64_sequoia:     "1fa5b7a0d2e0d468c0018ca6aa5ec43e388b86b0547971e0c134b8be06d91f0d"
    sha256 cellar: :any, arm64_sonoma:      "839cd0e0b292dc4ae1e908c0cf7f341572ccc7b507e78b37cc6a5c36ff20b6fb"
    sha256 cellar: :any, arm64_linux:       "b276e1137530e11c518c02fce240eabdd8e312ac13dff8284dba017d5767927e"
    sha256 cellar: :any, x86_64_linux:      "a2884ec317554524a1fa52fab1de0a72f380c0db5bb7ebadc8819a4d33b328cb"
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
