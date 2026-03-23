class ForgejoCli < Formula
  desc "CLI tool for interacting with Forgejo"
  homepage "https://codeberg.org/forgejo-contrib/forgejo-cli"
  url "https://codeberg.org/forgejo-contrib/forgejo-cli/archive/v0.4.1.tar.gz"
  sha256 "8f6a93c5f97e45308aead0154d4ec53e672ca90ab0809db543cde6be8078729e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://codeberg.org/forgejo-contrib/forgejo-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ecea1142d8a21c109d66da88aa7c591d240e40dd6ba3d5727ddb1031b1be4e02"
    sha256 cellar: :any,                 arm64_sequoia: "7f5a2d7e6eecfad0a8e0efb319aa0a72c854ba18012817b5c77d5f621d9650b7"
    sha256 cellar: :any,                 arm64_sonoma:  "e01394831fa782d2cd8c26cc11fad03523d002ef14ff43a0112580ad7f909d04"
    sha256 cellar: :any,                 sonoma:        "9b9b4b63125dda6e7165dd95e59099c27fce621560c812ac959b6a7e9d3d3f4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2595dda3beee936b2de15b5b0469ec103526349234c8301c51f6d8ca694bd21e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "983394df6100e0c3c26a2b3283f95c5bff1ffd199a3f53837d11eebb4746fcb8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fj", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fj version")

    assert_match "Beyond coding. We forge.", shell_output("#{bin}/fj repo view codeberg.org/forgejo/forgejo")
  end
end
