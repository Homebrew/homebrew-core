class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v7.8.1.tar.gz"
  sha256 "42d94e3e40654a1bb43399f75ea5c9a5f99d4b920b5fae20a46d085b548c4916"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67776495afdbba9316fd487e2adbd88a99cb08b18c73a893a61fd767eb0ea26f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b560adeff500e887ea009101ee42462740aa3dfb838b9df93bcad232d371c75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf022cc48a1da1752712c95258d8c53034242313dfaa10add045b553bccd408a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8368be4ad77261cbf56581d0159ca4a96ad87eb437901942f7a20c2a6a0b5ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebc600bcff59189985389af9d64cdeec69089926740ee2ee181f3508ce27387d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b9541d2f5ed3b56e57c081fe8f5747b41911eedc0c57f5706180041e89070a1"
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
