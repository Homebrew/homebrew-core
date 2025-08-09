class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v7.7.0.tar.gz"
  sha256 "f5e20b438f32ea825caab4c773845117a9e2a829371ac37da5513672f429c173"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ca9cfaa5ff28d0ef442acc7174b2c81b271d812755de6c58ba3020441cf9a76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29e598179117801bc623728e1089bd11c64f53af7ad5263817e43579552b5db7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "834e2df17c516cefb5498fb720d11f457da4a43938080eba0dc8f8ca8da17d48"
    sha256 cellar: :any_skip_relocation, sonoma:        "4050c8d42ff1186a2cdd3478e995aa29e4e4f138e10895b34607cd079e8f23c7"
    sha256 cellar: :any_skip_relocation, ventura:       "96bde797760d62f3d0d07ba73f6bba56ec1e92b28765a8d87b97afdd8d6703b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3042eb5fb45b080462a85fcebcf8a4e786093eddffbb5b8b5971d8e62f48cbb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6acd0f8daf600a06711d9d7dad23b100ec6fd484fd9dbd85d050ceca0550ee6"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "zip" => :build
    depends_on "elfutils"
    depends_on "openssl@3"
    depends_on "systemd"
  end

  def install
    # Use correct compiler to prevent blst from enabling AVX support on macOS
    # upstream issue report, https://github.com/supranational/blst/issues/253
    ENV["CC"] = Formula["llvm"].opt_bin/"clang" if OS.mac?

    system "cargo", "install", *std_cargo_args(path: "crates/aptos"), "--profile=cli"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end
