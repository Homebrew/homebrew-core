class EgExamples < Formula
  include Language::Python::Virtualenv

  desc "Useful examples at the command-line"
  homepage "https://github.com/srsudar/eg"
  url "https://files.pythonhosted.org/packages/59/06/7281154a4cd961f56302d9cac300cc8fc965b16d04ce797ed622a2f53586/eg-1.2.0.tar.gz"
  sha256 "ac9827824c2c9aee0fd0a54ca57440021a0a87868b503b215c2c273a035bef59"
  license "MIT"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "204831d83039555366ef695c6bace02cd9898c4580cb81c22ea984594d74c020" => :big_sur
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
