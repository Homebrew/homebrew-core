class IcpCli < Formula
  desc "Development tool for building and deploying canisters on ICP"
  homepage "https://dfinity.github.io/icp-cli/"
  url "https://github.com/dfinity/icp-cli/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "9fc1eb079e93f170a5fe9122e4814d71f5fb4987ee3a9711df64224889db1f52"
  license "Apache-2.0"
  head "https://github.com/dfinity/icp-cli.git", branch: "main"

  bottle do
    manifest_sha256 "7e49bc12505e783724890f187f7d42ab55a91a96e85c49724324a56b81e367d1"
    sha256 cellar: :any, arm64_golden_gate: "35bc94b20290ef350baee8a752e530d024de800b4cf86e86c32c5cea2d98a279"
    sha256 cellar: :any, arm64_tahoe:       "2b4703440db3db9be998c853a83a86d4ca201293d7a850d118f820eb4c43b5b3"
    sha256 cellar: :any, arm64_sequoia:     "77cde8d0f6c81fe5d5130bb414e7ea4874aa593071f22bf17d5e442e807ef858"
    sha256 cellar: :any, arm64_linux:       "6bf131dafcb98b6842f85170809f1ed6763569a512805c6c9305870f4bd814c9"
    sha256 cellar: :any, x86_64_linux:      "e5954aabd6e24cb32299b275254f1e597a146199630bd3bdf64488a32d43d60d"
  end

  depends_on "lld" => :build # for `wasm-ld`
  depends_on "rust" => :build
  depends_on "rust-wasm" => :build
  depends_on "ic-wasm"
  depends_on "openssl@4"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "dbus"
    depends_on "zlib-ng-compat"
  end

  resource "candid_ui" do
    url "https://github.com/dfinity/candid/releases/download/2025-12-10/candid_ui.wasm"
    version "2025-12-10"
    sha256 "359e217aed87044d24155df974fb4501dec02f676b9651f040a8dfe1ac0c9ed1"

    livecheck do
      url "https://raw.githubusercontent.com/dfinity/icp-cli/refs/tags/v#{LATEST_VERSION}/crates/icp-cli/artifacts/source.json"
      regex(/(\d+(:?[._-]\d+)*)/)
      strategy :json do |json, regex|
        matches = json.dig("candid_ui", "url")&.match(regex)
        matches[1]
      end
    end
  end

  resource "proxy" do
    url "https://github.com/dfinity/proxy-canister/releases/download/v0.1.0-beta.1/proxy.wasm"
    version "0.1.0-beta.1"
    sha256 "9e5abf27930b06df7f50c4baa1ec71b7e53408cb81849054fc51a1825eb6c5a4"

    livecheck do
      url "https://raw.githubusercontent.com/dfinity/icp-cli/refs/tags/v#{LATEST_VERSION}/crates/icp-cli/artifacts/source.json"
      regex(/(\d+(:?[._-]\d+)*(:?[._-]beta[._-]\d+)?)/)
      strategy :json do |json, regex|
        matches = json.dig("proxy", "url")&.match(regex)
        matches[1]
      end
    end
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
    cd "crates/icp-cli/recover-cycles-canister" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    ENV["ICP_CLI_BUILD_DIST"] = "homebrew-core"
    ENV["OPENSSL_DIR"] = dep("openssl").opt_prefix
    ENV["CARGO_TARGET_WASM32_UNKNOWN_UNKNOWN_LINKER"] = "wasm-ld"
    ENV.append_to_rustflags "--sysroot #{HOMEBREW_PREFIX}"

    # See https://github.com/dfinity/icp-cli/blob/main/crates/icp-cli/build.rs
    # and https://github.com/dfinity/icp-cli/blob/main/crates/icp-cli/artifacts/mod.rs
    artifact_dir = buildpath/"target/icp-cli-artifact-cache"
    resources.each { |r| artifact_dir.install r }
    artifact_dir.children.each { |file| mv file, file.sub_ext(".bin") }

    system "cargo", "install", *std_cargo_args(path: "crates/icp-cli")
    generate_completions_from_executable(bin/"icp", shell_parameter_format: :clap)
  end

  test do
    output = shell_output("#{bin}/icp identity new alice --storage plaintext")
    assert_match "Your seed phrase", output
  end
end
