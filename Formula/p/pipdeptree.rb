class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/f1/22/af4f7e301cf70dc5ecb6f25366122f3925637013376971e2356ebde82695/pipdeptree-2.16.2.tar.gz"
  sha256 "96ecde8e6f40c95998491a385e4af56d387f94ff7d3b8f209aa34982a721bc43"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f746ad662f4718ca962a782c0ef965e3b31d1552e033519614bb93b27b789193"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2844adb32f9c4897ae5c48939d6db17cd3479b41f2ecd3f14360bd680b97f958"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00c41a65978e85c50b7c721e27e032e78726401cb27327ff25edd2c759ba8d1a"
    sha256 cellar: :any_skip_relocation, sonoma:         "2cad9f3a3b95464b2c0b7b243d20189e86bb63a44d8225ce383a59d32120be9f"
    sha256 cellar: :any_skip_relocation, ventura:        "2a2b931a38db53ca119d320aa4821eacc81ca5382ec787238142a623d02c21c0"
    sha256 cellar: :any_skip_relocation, monterey:       "55b6d9f26389bf752ca1f44a74ce41bf027bef01b88916e97de21a0fcd3457ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59793c5102220b9a47741c2570148ee71e246df64218d50239116e3f2188f2c6"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end
