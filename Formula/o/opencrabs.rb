class Opencrabs < Formula
  desc "Autonomous, self-improving AI agent in a single Rust binary"
  homepage "https://opencrabs.com"
  url "https://github.com/adolfousier/opencrabs/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "9174e924a3a00406a2a7820299357192e1951ccaa3723f536a7c4a3c00a82dd4"
  license "MIT"
  head "https://github.com/adolfousier/opencrabs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b09b55c0f72784c0a9cff8086ae402c47b24234f4789904dc1588c76f8b1e2a4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d0fb86db7d41b30f323fa778c71e7d0c2c7c610f4575c464a524e994cbf31340"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0a6c6db14efb81be3ef6bdd71b00a67461bc76efacdf657c0b78e547b0681164"
    sha256 cellar: :any,                 arm64_linux:       "f383dff99f7f720b17cc594277c45d0ea5be1f925c58e0c45a1b7cae691d2bea"
    sha256 cellar: :any,                 x86_64_linux:      "7a58d757c785d969da60e12d60524f4bdd6255e852929e764f161599d4925c4b"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rtk"

  on_linux do
    depends_on "alsa-lib"
    depends_on "openssl@3"
  end

  def install
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm").to_s
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s if OS.mac?

    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"opencrabs", "init"

    config = testpath/".opencrabs/config.toml"
    assert_path_exists config
    assert_match "[provider_registry]", config.read

    assert_match "Database:", shell_output("#{bin}/opencrabs config")
  end
end
