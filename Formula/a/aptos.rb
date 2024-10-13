class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v4.2.3.tar.gz"
  sha256 "59a15ff1f7394430d192e3c91d3a003c76f95f8d2addc8c2a31c685dc2f0b272"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f36c3ce127be71f99d3a5ac46203bc20eb693edfa2cea297419ba3fe895a7ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ae86900262963e766c103ad115675f365ebc18cd71370b6ab6a1fe0cf25a4b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ccfaa92846675cddd5eec19016ac6c20b2c05b6bf41406ae3003ef51d0320784"
    sha256 cellar: :any_skip_relocation, sonoma:        "d09bf7f00c281a9805ffc554a9464bdc4aca635db2958cad5abdeb99aa2214d4"
    sha256 cellar: :any_skip_relocation, ventura:       "79b271d8f971210b56887ee2d17c1cb39ffc372a90496402336d858dc3f7858f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "879d87c1054a486db3ea7f3d40dcf589e42cee0d00c5408f080e43f12a32b894"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "zip" => :build
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
