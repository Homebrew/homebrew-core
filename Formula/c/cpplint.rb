class Cpplint < Formula
  include Language::Python::Virtualenv

  desc "Static code checker for C++"
  homepage "https://pypi.org/project/cpplint/"
  url "https://files.pythonhosted.org/packages/18/72/ea0f4035bcf35d8f8df053657d7f3370d56ff4d4e6617021b6544b9958d4/cpplint-1.6.1.tar.gz"
  sha256 "d430ce8f67afc1839340e60daa89e90de08b874bc27149833077bba726dfc13a"
  license "Apache-2.0"

  bottle do
    rebuild 5
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1ebcdaadbf95e043eee26a5e61ef099d163f02b1024bfd6a48e25b43bb1e40a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "160d2679081ce1941f4c026ae9808ad2b7611afb937b6a3536b00be8709796f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ae38619920a9e68a04561d58ddfdbdca7a214beaa4f2d7a0a53a37c1da3e4db"
    sha256 cellar: :any_skip_relocation, sonoma:         "491893d9094e7f1565ae342c8aceecde9f7ccbc011fe10546b2690507bd8fee1"
    sha256 cellar: :any_skip_relocation, ventura:        "4e6456089c2d047c90d1533bbe3ea2be9fe341ed595c990eeff4a4f44b31be6a"
    sha256 cellar: :any_skip_relocation, monterey:       "5f433ee51e12a95f15dae3023877f3e84a6cb87ae27cc20f7052a5de39e9d7df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7f80a3e8068bebc91afb5c7cb391aaddc15bc098ae7f5698a4b5bfbd09439dc"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources

    # install test data
    pkgshare.install "samples"
  end

  test do
    output = shell_output("#{bin}/cpplint --version")
    assert_match "cpplint #{version}", output.strip

    test_file = pkgshare/"samples/v8-sample/src/interface-descriptors.h"
    output = shell_output("#{bin}/cpplint #{test_file} 2>&1", 1)
    assert_match "Total errors found: 2", output
  end
end
