class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/ad/9a/9999b3052c08af15fbc4e9420cb74456b887b053f31039f54679c370ed33/pipdeptree-2.20.0.tar.gz"
  sha256 "bea21daf9ccb991650a237bfa4730932c7332c3c37cce7c4b4fade43ee5a2be5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e77022c7a57eaa2d948627415ecaa1e7e196907147ced1b3e8536c3c1c79af80"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f44e5ef2de8080d7db21ba520d0fd299d02c033503506b2a1b21444e5a77f526"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d539404df79af86048118b629f78e5bf0aa1493a7cd437306ddeea5d53c2d94b"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a87172c5c89079458cd783523c804fb3b9eacd8f8a129f0fe2b90336d261c91"
    sha256 cellar: :any_skip_relocation, ventura:        "5ce894d8ed989f5beb5f0ef8fc8ebe5aa354a99d7d749783b8691bec2c788450"
    sha256 cellar: :any_skip_relocation, monterey:       "8f0d4e9803e8fa0181773c847f2d4c16cf8298389e48c739b6a58c45081ea5de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "966e84b775c903e49dda1f6f32b17828f1a116b926bce1886cb552afae9cdff9"
  end

  depends_on "python@3.12"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end
