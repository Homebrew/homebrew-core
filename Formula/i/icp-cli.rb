class IcpCli < Formula
  desc "Development tool for building and deploying canisters on ICP"
  homepage "https://dfinity.github.io/icp-cli/"
  url "https://github.com/dfinity/icp-cli/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "98e79229b3b89b77aaa6237a5540ca719586e17501c7886dbfd5faf0a32d2364"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "931c44cbf30867a08ba2671cbdc2ed068230a6586b2d3d295da4f339d5307d55"
    sha256 cellar: :any,                 arm64_sequoia: "13fa33c5b25a74bf5c27e131fde953da5e63c4d2e11f6acc3301cc82fb405cb6"
    sha256 cellar: :any,                 arm64_sonoma:  "bc77e2d6912022cc6090a6ca0ba2c76ff54530ca5492a39290c704940e66ae73"
    sha256 cellar: :any,                 sonoma:        "2ebf90d995c41ec55eafc49853ed25a150d1b38e5550dc092514f9095f0be190"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da19c578e62ea522a4110dd4ffe8498505e52908c60b627f249c6a371bd9214b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c19fed600ccf757a23883d591c3fc3ed23139af2d2c262f5ad88e4d02d9e02b"
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
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "crates/icp-cli")
  end

  test do
    output = shell_output("#{bin}/icp identity new alice --storage plaintext")
    assert_match "Your seed phrase", output
  end
end
