class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v7.2.0.tar.gz"
  sha256 "135e0c1799cc6bfe4e570d40817f8548c8e89ddb06c690ed4737e56824334222"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0206105fff368a299a90a564d3bc2721310ebe7c73d45a3d8535263cc318028"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50a2913aef29c7bbfce6b09ccff72c0d688fe68023a556dbed2374cb815d2451"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c902ffbdb542944f9c8f41cb82eddf6caed2a0f4590b1d6838d91c39a50de28e"
    sha256 cellar: :any_skip_relocation, sonoma:        "82ec06f8000c62227eb01550487a8e3be5cc0204683a579c44018013ecd5168a"
    sha256 cellar: :any_skip_relocation, ventura:       "61551d586996b1b498087bc323cee13c2885a8102566633e8c48a804428664bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c75d81c3c08217ec4ee7473c429ac545d48e9a0a1a2a9574829aff9f265ddab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc1f7c0851ecd2c3d0acfee0572bfd39eb83f2ae35655ad6366e2b56b9bfbd4a"
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
