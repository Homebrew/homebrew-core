class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "483d918c6cbeca251977b033e58c9f67d9be3f1bc4ab4083437bea69c9fbdd3b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e52791c090919e8c5f34fb749064fc6e194edd2ea83a29839c2d6b4ce99cc6f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f5ea03c2405b5a0832195a60f11e73b55495ffe7a280ed763c17cf0e7464da3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26fc959bce3fe67b72f5e9064c3c76f38267dbf83ce3f0947a60bf225e918a8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2b542a41c428ca6808a37fcff69b948d548c0466bc8404b6826aa2ecf69cb22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dec8bf8cbaf9ad4ea88e85aee3d2c9b759ed3c481999a5a64b50329742cf8c89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08a6dee83c091e9aca77e0a6a0d0ce5283f4fd107f2521a408f3a0f00b114230"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build rquickjs-sys

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")
    assert_equal "high-contrast", JSON.parse(shell_output("#{bin}/fresh --dump-config"))["theme"]
  end
end
