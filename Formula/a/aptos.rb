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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a625e0b1d809bb60f862ac3e12fbebf1f9ded15317bbdd659547f625e220e04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61c0ec18f7ed1b8304bc8800998e1ba1fb13ff0639058b5265b106551843200b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4a9534a65470776222362bec91c86b3c0f6fb9e6302d9959681e99ffada5f85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9c61e732eed0c6d32379c516f0d233f735c74e6e1a94751b8a992ffa1973135"
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
    ENV.llvm_clang if OS.mac?

    if OS.mac? && Hardware::CPU.intel?
      # Avoid building the assembly and use C fallback only instead in blst crate to avoid build failures.
      # TODO: See if this workaround can be removed at version bump.
      ENV.append "CFLAGS", "-D__BLST_PORTABLE__"
      ENV.append "CFLAGS_x86_64_apple_darwin", "-D__BLST_PORTABLE__"
      odie "Try to remove `CFLAGS` workaround!" if build.stable? && version > "7.7.0"
    end

    system "cargo", "install", *std_cargo_args(path: "crates/aptos"), "--profile=cli"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end
