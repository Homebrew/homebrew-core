class AdbEnhanced < Formula
  include Language::Python::Virtualenv

  desc "Swiss-army knife for Android testing and development"
  homepage "https://ashishb.net/tech/introducing-adb-enhanced-a-swiss-army-knife-for-android-development/"
  url "https://files.pythonhosted.org/packages/c4/a5/9066bb8c0dd47025aafbb3388b87f68df02f2cf64a83933feee0b3c7c259/adb_enhanced-2.6.0.tar.gz"
  sha256 "ead467df4e0e4fc964007c62b0b55801a5f158793bd551ec4b25154801fc3f5a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5acfb19069d8d153e2e299d880d17c94ebedf2aeddda6a11447978a615eb8a3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be8f29d3429a042f03692f57e5ba81d29274bb90d3b4dc5a5f4ba23a595d1e76"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b6d507e23a98bcf245172a6141eb5af9865f56ec5961c0b592f160c7267bea0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ac54642e1b66b5237cb6092b4e354407a5a2c8e58cc9a7fb9ecfdcc68e80f94"
    sha256 cellar: :any_skip_relocation, ventura:       "f1c7d11dbaa3543c3265673c5e5920e61bcfe71d284419d2a60d39ebafd79c30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8fc53e7dcbc88fd7cfb3bfe50e5313ede172aeee9bde7f8408204f3f7aae6db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3a552e117835c2e8d9935f73c7fae1ad107bd298598ccf5d4f0a7bbc939270b"
  end

  depends_on "python@3.13"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/adbe --version")
    # ADB is not intentionally supplied
    # There are multiple ways to install it and we don't want dictate
    # one particular way to the end user
    assert_match(/(not found)|(No attached Android device found)/, shell_output("#{bin}/adbe devices", 1))
  end
end
