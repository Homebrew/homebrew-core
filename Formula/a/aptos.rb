class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v7.5.0.tar.gz"
  sha256 "dc3a0273fcd03eefeff20ccf9c032d019a56f8017dda0671031bb373255db542"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d9f81877ab7dd332337e25a989a059c6c1ba30f41964b683f9279651bae63e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b25707444d95567df7e1546b53c85d7c714e1b9ab528caa997c7cf9cf8336566"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "281fbe65d978f0bf8a9215e87b7727b5ebb93c5cfaadb4e893a33d58cca74d3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad32db913799ae7d16093b60954d3afa5f9cfd688144ef175ad8d37c9feb57d0"
    sha256 cellar: :any_skip_relocation, ventura:       "45fba6d93447ddbd3db6f825f013c01ae8fea99bb262c37bd97538fbc127b27e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41e1ab42217d00c5c0a91f0254b5b4e87f4db5c5285f7a88c8aac9fa935b0d01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9f5faec3730010ac97f3f951b6eea6d7e7b20268df4330f47bb528393bb3783"
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
