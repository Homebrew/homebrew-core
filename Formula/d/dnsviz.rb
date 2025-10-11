class Dnsviz < Formula
  include Language::Python::Virtualenv

  desc "Tools for analyzing and visualizing DNS and DNSSEC behavior"
  homepage "https://github.com/dnsviz/dnsviz/"
  url "https://files.pythonhosted.org/packages/59/91/aa152739fea36d4456fbcc71a26333ffef587526d722c10c281ab12a6a35/dnsviz-0.11.1.tar.gz"
  sha256 "203b1aa2e3aa09af415a96a0afc98eef4acf845ab8af57bf9f7569bd13161717"
  license "GPL-2.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "74492b484c0ba26184440551227d4fd2ec585819dc066c163e75d9edba6845cf"
    sha256 cellar: :any,                 arm64_sequoia: "e3d5f3ae2ef66744d026e840df9aa8c945593ee181a8b7f5d6f38eebbc584b78"
    sha256 cellar: :any,                 arm64_sonoma:  "92276aac69e9a96ee9334b572d2987bea7d9fcb1a1565b68494b3d6283f0319d"
    sha256 cellar: :any,                 sonoma:        "7b5fbbb2215e372dca1f3470a26cd433f045371a6067695b158a77ef5aa14685"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3249241f1b4418a645b618d971ba42110c48346949de6577646ee9627c79acbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9093a63ada9c090b9b9fa3d1726b880cac3e4fc3710ee18be16a6ad7cf32b675"
  end

  depends_on "bind" => [:build, :test]
  depends_on "pkgconf" => :build
  depends_on "swig" => :build
  depends_on "json-c" => :test
  depends_on "cryptography"
  depends_on "graphviz"
  depends_on "openssl@3"
  depends_on "python@3.14"

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/b5/4a/263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829/dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
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
