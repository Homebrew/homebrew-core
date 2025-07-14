class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v7.6.0.tar.gz"
  sha256 "3c1650f253b5c9b213c51d1de130f671af118a5611897214150ddcb4bcd3855b"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a0d88de34dde92d1d25a8f545ef7c1d19ac53f35f725389dced4a87a4562810"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf628eed0a1060cc92151a0a8fb400ba6f4c755aea05904c300ccc7ba4bb8a48"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e9137d8a256576010f653d59ac59e9687efb4e2a30cfacf45c3aeb07997c343"
    sha256 cellar: :any_skip_relocation, sonoma:        "70a5b0dc7ed1150e2978642eb75965dafb7f9afb34113c0c952cc9417e3c211a"
    sha256 cellar: :any_skip_relocation, ventura:       "ed43d1a6bb7c33819390eb3b2e6d13a79ad3cae9fde21cc820c24169653f9323"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96d26173b895e402447e01879998297d17aef8654cdbebd749f5e8c71a073a56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eec10834e5669a9da38277cc5c264862cc12c180d1268ae40e3956503067394b"
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
    # FIXME: Look into a different way to specify extra RUSTFLAGS in superenv as they override .cargo/config.toml
    # Ref: https://github.com/Homebrew/brew/blob/master/Library/Homebrew/extend/ENV/super.rb#L65
    ENV.append "RUSTFLAGS", "--cfg tokio_unstable -C force-frame-pointers=yes -C force-unwind-tables=yes"

    # Use correct compiler to prevent blst from enabling AVX support on macOS
    # upstream issue report, https://github.com/supranational/blst/issues/253
    ENV["CC"] = Formula["llvm"].opt_bin/"clang" if OS.mac?

    system "cargo", "install", *std_cargo_args(path: "crates/aptos"), "--profile=cli"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end
