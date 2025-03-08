class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v6.2.0.tar.gz"
  sha256 "feb35b7a4ff80c1297bcfc680972a9adc85e82e3ea98059da7833643cd5c4c8a"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a07395c0d806327f694248eca8da50c33721a41a9e53553a68404e2e44f1f24d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f120a076268e03160a6b274255ec53fcf8caf82ed83d7272e49a4d657a37217f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d18a76ea74f5bd3afa89ac2647a0212cd4977e3d898802f5cdcdebc674a2d5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c09fdae09e212ea9fd9cc387e84f63c2b6ad6cf31e669f778c675410bf7d74a6"
    sha256 cellar: :any_skip_relocation, ventura:       "6e32791729c7d581d3e0dc347b7f267bd4f8a2563f4c06c675cba69455eb5839"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85af82415db0c1b552f7583f5fd184024218202f13a3e5ba29c22d1d61035751"
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

  # rust 1.80.0 build patch, upstream pr ref, https://github.com/aptos-labs/aptos-core/pull/14272
  patch do
    url "https://github.com/aptos-labs/aptos-core/commit/72b9657316c699cfbef75216f578a0bd99e0be46.patch?full_index=1"
    sha256 "f93b4f8b0a61d245e13d6776834cec9ecdd3b0103d53b43dcc79cda3e3f787ed"
  end

  def install
    # FIXME: Look into a different way to specify extra RUSTFLAGS in superenv as they override .cargo/config.toml
    # Ref: https://github.com/Homebrew/brew/blob/master/Library/Homebrew/extend/ENV/super.rb#L65
    ENV.append "RUSTFLAGS", "--cfg tokio_unstable -C force-frame-pointers=yes -C force-unwind-tables=yes"
    system "cargo", "install", *std_cargo_args(path: "crates/aptos"), "--profile=cli"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end
