class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v7.9.1.tar.gz"
  sha256 "b67872d67f432e1a3bdaf5d2a38ddae37f64a076e9a7c682525ea294be4042f2"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "daecfc7d11b167cf0fd9c0ea8cf73cc2cf86c35031c3e7e33eda982cc90a1d35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20a05e33a47dd7775848b9634c37013832cb810b60fd43fed7667c0879042a06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "977188dce23540a779cc87ccef696d60e0da32043e375db87fa2fcf1c478868d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0052dea520d9b7d2eea828cf1b4c724d44bb53b96e3dfbb463784ebf0ca6a33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5eb12c375093b2af3da2eb786e7f1f5299ba89c50a1d38e74ca2556e6b067899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30f15c4d0bcdb7d1faac095336eca9f57045dc54cf5457a8c18fb83060e2d253"
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
