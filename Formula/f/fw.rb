class Fw < Formula
  desc "Workspace productivity booster"
  homepage "https://github.com/brocode/fw"
  url "https://github.com/brocode/fw/archive/refs/tags/v2.17.1.tar.gz"
  sha256 "9b87924c5384c65f7012ae545d40e550f830fdf1b3e75bbbde5f9b4bd64aab86"
  license "WTFPL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13c029efb1090dd4fcf1a15087e35ffddcfd53833066cf3024ac07a7fccf73da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b6f7ccf8695f125669af21a167f04682de8b06bc59ed0449f25f014747777d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "682e2015dae56e1b1d8bd901d4b22797e8957fba1f43644b9a1c2d3dbaaaaa2f"
    sha256 cellar: :any_skip_relocation, ventura:        "324e0456a01ae8991c19c03be19ac8522bd382583bc1d541c7a3e36710a3e127"
    sha256 cellar: :any_skip_relocation, monterey:       "46cc3b2ed9cf8ba4ba031e2fddbe5692be73ef1033e1792987edbdc07644adf0"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea5da33052b73031a05f00e3e357f15824f5e2e39251b1cc65af4118f893f449"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bda9d01cd469e187a55c2dae61108572942305cd763ceeecdf97e4d09e3cd7ea"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  resource "fw.1" do
    url "https://github.com/brocode/fw/releases/download/v2.17.0/fw.1"
    sha256 "b19e2ccb837e4210d7ee8bb7a33b7c967a5734e52c6d050cc716490cac061470"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    man1.install resource("fw.1")
  end

  test do
    assert_match "Synchronizing everything", shell_output("#{bin}/fw sync 2>&1", 1)
    assert_match "fw #{version}", shell_output("#{bin}/fw --version")
  end
end
