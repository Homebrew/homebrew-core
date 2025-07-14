class Dnsviz < Formula
  include Language::Python::Virtualenv

  desc "Tools for analyzing and visualizing DNS and DNSSEC behavior"
  homepage "https://github.com/dnsviz/dnsviz/"
  url "https://files.pythonhosted.org/packages/59/91/aa152739fea36d4456fbcc71a26333ffef587526d722c10c281ab12a6a35/dnsviz-0.11.1.tar.gz"
  sha256 "203b1aa2e3aa09af415a96a0afc98eef4acf845ab8af57bf9f7569bd13161717"
  license "GPL-2.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "caed4a974f2a1111d2a16262e543e453902627186de111aaa61ddb8032dd35a1"
    sha256 cellar: :any,                 arm64_sonoma:  "1581924ecb9d02d792a419193ac546d9bd23cf9eebb6c24036057215bb426155"
    sha256 cellar: :any,                 arm64_ventura: "5298cc8506b62c7a0ab4d777bac991fb323e4fb7aeb3df58c9cdbe30a5705758"
    sha256 cellar: :any,                 sonoma:        "868cb74462053d69ac21313706d77ee77784e0f16bc1bfa9f4954c75f786d492"
    sha256 cellar: :any,                 ventura:       "ce1d41d45c74b5fd99a9304908e6f2e0c1b96b6e4c1885092798125107c6af0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2bf1c4ac13ab45adc76818b196bc0a29cdb15bebb708418cfe1ebae5c851348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c57ff69d2c3f50edf3a9ae8c07f2d1d0ba7c0d72dc697c58b46363bb3c3895a"
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
