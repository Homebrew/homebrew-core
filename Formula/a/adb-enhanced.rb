class AdbEnhanced < Formula
  include Language::Python::Virtualenv

  desc "Swiss-army knife for Android testing and development"
  homepage "https://ashishb.net/tech/introducing-adb-enhanced-a-swiss-army-knife-for-android-development/"
  url "https://files.pythonhosted.org/packages/82/11/1228620ea0c9204d6d908d8485005141ab3d71d3db71a152080439fa927d/adb-enhanced-2.5.22.tar.gz"
  sha256 "b829dcb4c9a9422735d416a62820de679bed8b08dfbff2014d46a525c39bc7d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bdf2f9aad3d0e66174694171ad61979e05c4d9ede01f6fe763c8a3a57115a959"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ead73d8a0fa21811a47787e6e4170e1fc91afffd62a3d987457c4e9d98231fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "329deefa3c598541c38baa46666890c962d679a21d0ecba377a50b4373f5b2c0"
    sha256 cellar: :any_skip_relocation, ventura:        "58db3296ce92d5afe942d37f0422e5e67729ab4b55955d73f810d3c546b4b53b"
    sha256 cellar: :any_skip_relocation, monterey:       "caae90d5ae7111c4354f43a33cc23643ef072e585fe7317100c4acdf73280b8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e141e2e5e569d6672b882c2b43e74c8b430232fa0e6f75c8b33699cf42b671bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "435f9ddd2f1852f03cc8c3358289f440a07e266748efb8c1913e6d9427c7d4e6"
  end

  depends_on "python@3.11"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d6/0f/96b7309212a926c1448366e9ce69b081ea79d63265bde33f11cc9cfc2c07/psutil-5.9.5.tar.gz"
    sha256 "5410638e4df39c54d957fc51ce03048acd8e6d60abc0f5107af51e5fb566eb3c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/adbe --version")
    # ADB is not intentionally supplied
    # There are multiple ways to install it and we don't want dictate
    # one particular way to the end user
    assert_match "not found", shell_output("#{bin}/adbe devices", 1)
  end
end
