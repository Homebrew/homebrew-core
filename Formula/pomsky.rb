class Pomsky < Formula
  desc "Regular expression language"
  homepage "https://pomsky-lang.org/"
  url "https://github.com/rulex-rs/pomsky/archive/refs/tags/v0.9.tar.gz"
  sha256 "bb9414b37c721e1f0dac373c6b250d278556f119e40cb1903b9f8a2238a972a0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rulex-rs/pomsky.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cde41360135f32e1dbff5262783389ca8d9cea35a0f37f4477354fc679603281"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f028bec0428e542dabf8421a1437cd8862ca02136f1ccb5b1ea11a340f59e426"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bcffeb4ebc8cdfe8aae2996081a941092fa8c6a7785389aa50ca5fe1a0af968"
    sha256 cellar: :any_skip_relocation, ventura:        "95d5c57f43e7755d9088a84f923ad68e3a362314113f5a4d1cdba046b352c539"
    sha256 cellar: :any_skip_relocation, monterey:       "75edb8c7e06b54fb78349392f60ab49e03844bf2c739a1a44f704347e75b9583"
    sha256 cellar: :any_skip_relocation, big_sur:        "f15b6afdad27659c8597194932104ca4adb3e49e6b619695547406c3c37c8e5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1c4516f29ca77af397d190e5a949a6a26d031477340df9cc6e512a5f10bacba"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "pomsky-bin")
  end

  test do
    assert_match "Backslash escapes are not supported",
      shell_output("#{bin}/pomsky \"'Hello world'* \\X+\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/pomsky --version")
  end
end
