class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v7.8.0.tar.gz"
  sha256 "ecd8f2bfcf8f4a9bcf9d349d784bc69cc837e0ac3673423437ba6074ec17e9bb"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dc9401ad736cf1b1f368e82e3931977ef549799a194c00dc92bc6ee9890c697"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fbefe653a7f98a738e643f85d784076d8526a34b3f02adfb9b5ef9785d20d75"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a959486558dc10bb9f04fd13cd571103119c43cc939c6c9731bd61bfdf79a307"
    sha256 cellar: :any_skip_relocation, sonoma:        "7884542f527cf83d2f999ea6a47987ce9e99ecb6e42dd763127c6347b9f376e8"
    sha256 cellar: :any_skip_relocation, ventura:       "aceb8a406ddd7e3309b9818dff42344d56d948ad3770ad5a14a0dfaacbcd2b9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59e079153513cbc364e318144348939846694157ed7d5c34b400b80a131af2dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5d258522041c9edf3f1037c1049f8522ded6ecd54dfc8807d84e4da73fc24c6"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "lld" => :build
    depends_on "pkgconf" => :build
    depends_on "zip" => :build
    depends_on "elfutils"
    depends_on "openssl@3"
    depends_on "systemd"
  end

  # Fixes build with newer versions of blst
  # PR ref: https://github.com/aptos-labs/aptos-core/pull/17349
  patch do
    url "https://github.com/aptos-labs/aptos-core/commit/87862b1bf0aaeb73f6f967957ec38354e74d5d31.patch?full_index=1"
    sha256 "f4893ea7b41f0a9402dd630f7c184352603ee121aae86cfc8cfb4e86ede7c827"
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
