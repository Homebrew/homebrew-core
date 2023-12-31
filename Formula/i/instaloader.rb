class Instaloader < Formula
  desc "Download media from Instagram"
  homepage "https://instaloader.github.io/"
  url "https://files.pythonhosted.org/packages/aa/94/93b6130a32ebaeec7671c65b2b0cc76e657de1113aebe82c015245aaaf8a/instaloader-4.10.2.tar.gz"
  sha256 "2ddf1b3e85977bf07141383dff5dab23b2c59ccf40a1d2d8696ad11d43bb8198"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4095f327b236f9c62a5d0d533381ba81cf8e99994a0270146df4f8ff7ad4c5fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f67389bf2a4677efa07b77714715ba75812c5b208b1b95356c58935707c891fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "931648118713e73d7341f412634c4a6778d383ef4485f017df5683baecba495d"
    sha256 cellar: :any_skip_relocation, sonoma:         "85019303273a16a5ea8df311c8fd7334e7af669e6face0e813e4fca0d20145e1"
    sha256 cellar: :any_skip_relocation, ventura:        "c70b975a16796910e64fdde6585fa92abe043dc85c2e6bc0c93c26ed64f95838"
    sha256 cellar: :any_skip_relocation, monterey:       "a12924882c0fef407cabb4a396aa941455efc70324288feb925d77fcebce1de7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00829fe250c78544ff06d2fffbc248e69893b9baa4ce5aceb6c7361aecf1db1a"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-requests"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    output = shell_output("#{bin}/instaloader --login foo --password bar 2>&1", 1)
    assert_match "Fatal error: Login error:", output

    assert_match version.to_s, shell_output("#{bin}/instaloader --version")
  end
end
