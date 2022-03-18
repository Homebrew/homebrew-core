class Ddcctl < Formula
  desc "DDC monitor controls (brightness) for Mac OSX command-line"
  homepage "https://github.com/kfix/ddcctl"
  url "https://github.com/kfix/ddcctl/archive/refs/tags/v0.tar.gz"
  sha256 "8440f494b3c354d356213698dd113003245acdf667ed3902b0d173070a1a9d1f"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b482723d37c8aa30089c7bc5f4c10664a7f25e4e0f7819cfe1611781b9b3654f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d948d479e3d967839131c366214016915831fbbbf82f8359839de8a84f787b75"
    sha256 cellar: :any_skip_relocation, monterey:       "7e3cd50b5f89286e9b06e2006cff8bcb84ec4581b1ff3140909ec097ef671d3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "de6da4df6f856e2029ecaa89fbaae1009e8bf987f2c96b5ab71ad88f7adc7d40"
    sha256 cellar: :any_skip_relocation, catalina:       "aa81b0a04e1ac0c6c2c4d9e37a4efd47f00081303c3bbee150da1681d0a1b809"
    sha256 cellar: :any_skip_relocation, mojave:         "cd30f6623021ae90a9e535f0a178935e21c7ad895154de4ec97fa506a4622a5a"
  end

  depends_on :macos

  # Apply 2 upstream commits to fix build failures with Xcode 13.
  # Remove with next release.
  patch do
    url "https://github.com/kfix/ddcctl/commit/d3ab6ecfd649fa8c335cd45d632cfc8ee2069174.patch?full_index=1"
    sha256 "59fbd6f9e0aefdc65de967c350b9ab353001972bbc1b8fbe1bffb458e81a2700"
  end

  patch do
    url "https://github.com/kfix/ddcctl/commit/8395b07150508305ff92ead307f1563163212383.patch?full_index=1"
    sha256 "11646455bcb08fd3d8daad4e311df39a26936c4bc5da9180474eed33ccc52256"
  end

  def install
    bin.mkpath
    system "make", "install", "INSTALL_DIR=#{bin}"
  end

  test do
    output = shell_output("#{bin}/ddcctl -d 100 -b 100", 1)
    assert_match(/found \d external display/, output)
  end
end
