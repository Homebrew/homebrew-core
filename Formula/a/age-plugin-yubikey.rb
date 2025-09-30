class AgePluginYubikey < Formula
  desc "Plugin for encrypting files with age and PIV tokens such as YubiKeys"
  homepage "https://github.com/str4d/age-plugin-yubikey"
  url "https://github.com/str4d/age-plugin-yubikey/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "65807403f0098569a473ffa76302b205da148a7f46b61fd331b8e323959978ba"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/str4d/age-plugin-yubikey.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "6801ea0c59df5851fb1340474d8e2f910ca64ce254cac752b5a02c1a21fbc723"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2c1abec9dc0158b55ab98a0e85e1e25ae5f9fded57604288b4f7991b38526dbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b00a1b3384bb12abb53559e7d45f7c00bc59cf253d437365ce1d9eba65c1ed43"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e53f702fa0b8742fa519c6605ce75ac46338e9cac6b5e94f28f5e1ac32476449"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12d3c578b51f4fa1a2b4c75fbbee4a5a749552a8e9f5df6f9cd0a6a15877f10a"
    sha256 cellar: :any_skip_relocation, sonoma:         "2473cd4b99557da25b8e2899b5cccc8238a0cb9704be98fb274438e06593cf09"
    sha256 cellar: :any_skip_relocation, ventura:        "e5b92cc016f5f44f1c646dd717fd2b502f32fe69e6f1d4272f65f417d96b622d"
    sha256 cellar: :any_skip_relocation, monterey:       "4dd83632a9120d7c0bd3d8cc220bba2bd9ef0530370b7a87276d9d7627925a33"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "db8aff3d27ae723dde79b70043a3a2dce5ade95446c7d3ece767cf56a29679ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82643b04b611338208b3bed82b767ade73d25bf088ee7bac22d678f4ce0b7651"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "pcsc-lite"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["LANG"] = "en_US.UTF-8"
    assert_match "Let's get your YubiKey set up for age!",
      shell_output("#{bin}/age-plugin-yubikey 2>&1", 1)
  end
end
