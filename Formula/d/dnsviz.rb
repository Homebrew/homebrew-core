class Dnsviz < Formula
  include Language::Python::Virtualenv

  desc "Tools for analyzing and visualizing DNS and DNSSEC behavior"
  homepage "https://github.com/dnsviz/dnsviz/"
  url "https://files.pythonhosted.org/packages/59/91/aa152739fea36d4456fbcc71a26333ffef587526d722c10c281ab12a6a35/dnsviz-0.11.1.tar.gz"
  sha256 "203b1aa2e3aa09af415a96a0afc98eef4acf845ab8af57bf9f7569bd13161717"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "00110e902d3a1519334f1226603864e95d9d93c669d43c6fbf37aa27b08915d2"
    sha256 cellar: :any,                 arm64_sonoma:  "7cd031019ebadc5e47683d83d1d5828b5eb3baaa058ea3d69fb74b1a97906c22"
    sha256 cellar: :any,                 arm64_ventura: "b2fbd7dcdf0549567e1da7bf6ea52f57be4a2abfc81ecaba08dda9ce5c35bc01"
    sha256 cellar: :any,                 sonoma:        "0682b0b1bbcd7b5e43d2304c3739f682eb29b6d47a1967f484bd3ba794d96ad6"
    sha256 cellar: :any,                 ventura:       "d1765ce90cc43961a8592c8abda79368e9cf9c1c0bc000fc536720ca0ab89e5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a96068801bd4e01adcc3a7441f41a498b0a6b88cc5b1fe8fbe6d5461975f6f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d105d485eb7a835fec8e4c6b7af690ba215c77b540a7d5b3954e2558e799e26"
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
