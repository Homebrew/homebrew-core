class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v6.0.1.tar.gz"
  sha256 "1164c28d062c34841795de76b6ec02f68c6b0ea4c1c8cb01aa786724b81b07d8"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4256bb674457e264fd9ffc80178097f20c3124f661c78309bc282fbc5618194a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4feb07e16b5241f02345484ab1bc0e82ab904a4beb597de62783b2fda10713a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc98f018da7685bfb53a80b21d4fdfe8b4fec8655195e08aaa96dd5b01e604a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6db322d4e3a3cae5d91d04583535bfd28eb3cf322a14b686e157ec3e1f6ed06e"
    sha256 cellar: :any_skip_relocation, ventura:       "64ecd029753afe84fa61436cf6d028b4868e14f2c71d81f0b57a2b7addfc0267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "233f08d80e335af6f75e58b669ceea57790612da9e0e049da1e2fe9ea727ed60"
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
