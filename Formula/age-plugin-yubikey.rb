class AgePluginYubikey < Formula
  desc "Plugin for encrypting files with age and PIV tokens such as YubiKeys"
  homepage "https://github.com/str4d/age-plugin-yubikey"
  url "https://github.com/str4d/age-plugin-yubikey/archive/v0.3.0.tar.gz"
  sha256 "3dfd7923dcbd7b02d0bce1135ff4ba55a7860d8986d1b3b2d113d9553f439ba9"
  license "MIT"
  head "https://github.com/str4d/age-plugin-yubikey.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d665ef1bbc559bfa4a217c72ffd3b5cbf3a3328011542881cc695feb3d156b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1555003a7a5038f24683ca5f6f2dc66913c99518d00a218c1c2cc4f3c65fc04e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44d21604e8bd515f30999a3aa018f1fa58777e63ed30c8958cd16fa10b6758fa"
    sha256 cellar: :any_skip_relocation, ventura:        "9923d88d3c57492eb4ebee271bbc25d30c96a20f316d2980f0691661c8762852"
    sha256 cellar: :any_skip_relocation, monterey:       "0c25f61d6a39223f03a30ac927c3696960c92f801fa2de5b1cd88d1eb4b81c3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "29021a7735ca80bef0a0203b12a5e60545c647ef36df11d4e96e2bbee03114d6"
    sha256 cellar: :any_skip_relocation, catalina:       "ebb3da6e34a60964092ef091785bf7f3bc52ac77718c5bc3b92b48068224720c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2380eb6016c5178c0b6308337606ecc87288fd6c1eab13dcbcac3d114f87dcf"
  end

  depends_on "rust" => :build

  uses_from_macos "pcsc-lite"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["LANG"] = "en_US.UTF-8"
    assert_match "Let's get your YubiKey set up for age!",
      shell_output("#{bin}/age-plugin-yubikey 2>&1", 1)
  end
end
