class IcpCli < Formula
  desc "Development tool for building and deploying canisters on ICP"
  homepage "https://dfinity.github.io/icp-cli/"
  url "https://github.com/dfinity/icp-cli/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "2a21eeb1b7804c75cce7b7c7945504f47bd04f372b14891b402c0f3876aac688"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ad2d36cd48c1bebb3edc39d7a3168e33f06b3d1eb343596fb4cf16315952ae03"
    sha256 cellar: :any,                 arm64_sequoia: "8399888205527828b68533c029e70d3ea2f2b5862cd532749dab033764e56008"
    sha256 cellar: :any,                 arm64_sonoma:  "6889557581c1aa56a0f6fd809808543fc7a6672aa6570345f3adf5b45b786418"
    sha256 cellar: :any,                 sonoma:        "c1c1ab0ba0b6ea46db8a369fed6dbf8ef41a6fb0914711ed89480334118b9fdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9820c099831ccd67456afd6447ce69edf576fcb63796b9ab7862b8dc34b28e8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92da040376b2908e12390c6580ce01433aa268bc403c59df5158491401010bc8"
  end

  depends_on "rust" => :build
  depends_on "ic-wasm"
  depends_on "openssl@3"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "dbus"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["ICP_CLI_BUILD_DIST"] = "homebrew-core"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "crates/icp-cli")
  end

  test do
    output = shell_output("#{bin}/icp identity new alice --storage plaintext")
    assert_match "Your seed phrase", output
  end
end
