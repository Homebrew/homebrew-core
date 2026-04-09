class IcpCli < Formula
  desc "Development tool for building and deploying canisters on ICP"
  homepage "https://dfinity.github.io/icp-cli/"
  url "https://github.com/dfinity/icp-cli/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "ec9d35ebc52b17946127e37f95eb0425ae459530b056c47d9a4d46449a999f39"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6c9ccbb08126a1e4974940ec45799ed2e187990d8d0fa31340a4b7b6276c96b6"
    sha256 cellar: :any,                 arm64_sequoia: "7abc3f1032f39de06c23271f89b9100df1d433f2be3d0b7870d90a3a69eed2d1"
    sha256 cellar: :any,                 arm64_sonoma:  "de08df93ca3674ec065375274dd7b9b6f53456ed157178372ae8772b5f8d4f25"
    sha256 cellar: :any,                 sonoma:        "dc793be1ac1ae65d061294a96fadf3363a99b41841389f1357c405b816d1730b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d04336c09f2159583be61dbe696c4f9f769b6a2e8e28f7edcb511dff8414ee3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee383984403504853eedd58e04b3d1ec138a80177a94d15cfa079645614c6800"
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
