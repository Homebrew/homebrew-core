class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v8.0.0.tar.gz"
  sha256 "5018e52ea0133b1ff13bf5bfd641c5a3dc3babab1e31e2cb04fafefcf76b1092"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf270867c35c1f890f99b783b104d2d934386b728d4c22196b23fadcbff4e473"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5430b40dfaf11025159ecef3a4bacb7901fa8901e3782e367a4858ae4bc1e22f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f25696c785b44bbc71b7f62097cd3bd5e6394f729f3db0b648a263fff4458686"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a7f1e4d50ebd677876a1976d88bacd2bda1d8f6c35b84546465f97b8b0ab242"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f232600c017d17bedf96288967f2501cca878ce8c70b732dab583fbd62de7ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c344740b73781278000d001427712b1e0afdfe6944180182b6d72db50037c28"
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
