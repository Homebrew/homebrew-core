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
    sha256 "204831d83039555366ef695c6bace02cd9898c4580cb81c22ea984594d74c020" => :big_sur
    sha256 "045e7e5b71cab053dc77b1391c5f95b22eafcff36907e9aee570eecda2f80894" => :arm64_big_sur
    sha256 "839e81e263addcbf1baaa179f0422a0a061a7a71f81f7a378017efa91f102ea7" => :catalina
    sha256 "a895c53ab1408e34514b41d24a7a4a2d878e18eaacf2a17b469dbff88a2b0a76" => :mojave
    sha256 "8c4eb15ac9f12f809dfe2e69196dea9e62ad7471275473092f2e94bfbc14ea83" => :high_sierra
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
