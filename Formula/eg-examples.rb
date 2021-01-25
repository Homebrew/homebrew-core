class EgExamples < Formula
  include Language::Python::Virtualenv

  desc "Useful examples at the command-line"
  homepage "https://github.com/srsudar/eg"
  url "https://files.pythonhosted.org/packages/8b/b7/88e0333b9a3633ec686246b5f1c1ee4cad27246ab5206b511fd5127e506f/eg-1.2.1.tar.gz"
  sha256 "e3608ec0b05fffa0faec0b01baeb85c128e0b3c836477063ee507077a2b2dc0c"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "348688d0ce1a2c1825d2e84a35f61d2cc4db44e648c338be7459133fe8f5d7c7" => :big_sur
    sha256 "3c3fb055e2133a02b36bf18841ff7cd10d6d769ef77d255ddf07e8485362c256" => :arm64_big_sur
    sha256 "4f49955a6032186f8e9013a5c9b458584436873586b7f2363653e0c079531675" => :catalina
    sha256 "0232745391eb98aad737439b0c85ba93d599fef62e906032c9da19df89b916d3" => :mojave
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal version, shell_output("#{bin}/eg --version")

    output = shell_output("#{bin}/eg whatis")
    assert_match "search for entries containing a command", output
  end
end
