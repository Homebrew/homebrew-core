class Movement < Formula
    desc "Move Everywhere"
    homepage "https://movementlabs.xyz"
    url "https://github.com/movementlabsxyz/aptos-core/archive/refs/tags/movement-full-node-v0.0.1-alpha.tar.gz"
    sha256 "baad3ea0f0651057ec0629445f3fe969b0ecf04399a1cdc9a9a0f5c4101afc06"
    license "Apache-2.0"
    head "https://github.com/movementlabsxyz/aptos-core.git", branch: "main"
  
    livecheck do
      url :stable
      regex(/^movement-cli[._-]v?(\d+(?:\.\d+)+)$/i)
    end
  
    bottle do
      sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
    end
  
    depends_on "cmake" => :build
    depends_on "rust" => :build
    depends_on "rustfmt" => :build
    uses_from_macos "llvm" => :build
  
    on_linux do
      depends_on "pkg-config" => :build
      depends_on "zip" => :build
      depends_on "openssl@3"
      depends_on "systemd"
    end
  
    def install
      # FIXME: Figure out why cargo doesn't respect .cargo/config.toml's rustflags
      ENV["RUSTFLAGS"] = "--cfg tokio_unstable -C force-frame-pointers=yes -C force-unwind-tables=yes"
      system "cargo", "install", *std_cargo_args(path: "crates/aptos"), "--profile=cli"
    end
  
    test do
      assert_match(/output.pub/i, shell_output("#{bin}/movement key generate --output-file output"))
    end
  end
