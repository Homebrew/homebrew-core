class IcpCli < Formula
  desc "Development tool for building and deploying canisters on ICP"
  homepage "https://dfinity.github.io/icp-cli/"
  url "https://github.com/dfinity/icp-cli/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "902298268006737ab64d7bd223b628d78ad17630c02a520ee64aa7562cf446dd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4c2fb0b6ba13fde801d51ceff5974bc82cff149be35816b04c5fee95f8106f0e"
    sha256 cellar: :any,                 arm64_sequoia: "542409f56beb34964da4a4a03f07f6b703d787d12ddcca4ff25f65a14b720cce"
    sha256 cellar: :any,                 arm64_sonoma:  "33ea96e7f07abd42b4ca0748196c79d1036fa42bfe7262c6c9cbfe1656043967"
    sha256 cellar: :any,                 sonoma:        "e316f61de63481d6c59b705fb78f60498fc7009405a2f46965685c59bd740ed7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e8edb3c595cca7d8dd4120961f9455d7d852c4ee57e9e7ff703f2df6fef664e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "780dd4dc2ce0e3643ac6aeb0aa8e7bfe4252d1f29ac4a03fcfc071bda6b61119"
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

    system "cargo", "install", *std_cargo_args(path: "crates/icp-cli")
  end

  test do
    output = shell_output("#{bin}/icp identity new alice --storage plaintext")
    assert_match "Your seed phrase", output
  end
end
