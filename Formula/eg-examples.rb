class EgExamples < Formula
  include Language::Python::Virtualenv

  desc "Useful examples at the command-line"
  homepage "https://github.com/srsudar/eg"
  url "https://files.pythonhosted.org/packages/8b/b7/88e0333b9a3633ec686246b5f1c1ee4cad27246ab5206b511fd5127e506f/eg-1.2.1.tar.gz"
  sha256 "e3608ec0b05fffa0faec0b01baeb85c128e0b3c836477063ee507077a2b2dc0c"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c998d2ecb20e008e38511d86247d6d7c5d01b8def623c77508ea62cb15870add"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c998d2ecb20e008e38511d86247d6d7c5d01b8def623c77508ea62cb15870add"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c998d2ecb20e008e38511d86247d6d7c5d01b8def623c77508ea62cb15870add"
    sha256 cellar: :any_skip_relocation, ventura:        "aa47a39ac7fa11e465914020ee475b3b9b5fbd22bbb32c9dedb515d8b0dbf8b5"
    sha256 cellar: :any_skip_relocation, monterey:       "aa47a39ac7fa11e465914020ee475b3b9b5fbd22bbb32c9dedb515d8b0dbf8b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa47a39ac7fa11e465914020ee475b3b9b5fbd22bbb32c9dedb515d8b0dbf8b5"
    sha256 cellar: :any_skip_relocation, catalina:       "aa47a39ac7fa11e465914020ee475b3b9b5fbd22bbb32c9dedb515d8b0dbf8b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aae0fe8abd670208bea20796e5854d315f26eb35a886677efe1976e5d7a00e04"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal version, shell_output("#{bin}/eg --version")

    output = shell_output("#{bin}/eg whatis")
    assert_match "search for entries containing a command", output
  end
end
