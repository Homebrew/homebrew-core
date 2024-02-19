class Instaloader < Formula
  desc "Download media from Instagram"
  homepage "https://instaloader.github.io/"
  url "https://files.pythonhosted.org/packages/65/2d/ffcd7916414b5bce2a497c39f015ec55e754f165a254cf3ac8ec76f3dc0e/instaloader-4.10.3.tar.gz"
  sha256 "168065ab4bc93c1f309e4342883f5645235f2fc17d401125e5c6597d21e2c85b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6c434f54b809056fee9a5acadd3552b49cbd6cc62f7ad0f2e5215733f9869e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9254edfbc8fa3a2ad60a4ebd18a4584e7aa0a761e2aa240a9d0dd08758cf837"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e339cb1efb4d2542583a345d3fe6233c7b6e77f774c8f3d04204456f7b46a22a"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb3231e46e9398ec7f9a6e0ec75f06e02d30dc432c8c2c48843e0bb0f9f2f8dd"
    sha256 cellar: :any_skip_relocation, ventura:        "dee8da1771db8dbf7eab558981cdd422edd0f90dbafa7073cd7270153b8ea93e"
    sha256 cellar: :any_skip_relocation, monterey:       "85c9374f7f0d7967cc532142090661e1a347810e4bbcb2ab84ef9a3764bf5f9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b608a4fa79a82bba5225ba00c8a931631637efce8c4c06a6d65e0a11940ba78"
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
