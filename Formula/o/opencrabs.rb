class Opencrabs < Formula
  desc "Autonomous, self-improving AI agent in a single Rust binary"
  homepage "https://opencrabs.com"
  url "https://github.com/opencrabs/opencrabs/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "41da3faafe9579f884e9ee20961436cfe35fc6048a3baf1614fbc346a89746b2"
  license "MIT"
  head "https://github.com/opencrabs/opencrabs.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8a5ca9280634938c64bbec4cb442ea9c3795bf7b2ec08b26803d071054a4c43f"
    sha256 cellar: :any, arm64_tahoe:       "e3c587d5030585a6ef4e16f0ca045b2e836ff6fbe4457b0ffa8f5bd1bdb74eb2"
    sha256 cellar: :any, arm64_sequoia:     "b0875312ba62a2f7a64c0e2581c560228fd8972f63a06a056a1337a17dd6b851"
    sha256 cellar: :any, arm64_linux:       "583b1d998a7c7c34fcae4c39b3f6a498b3b040033378e1f77b74f4d2f4771399"
    sha256 cellar: :any, x86_64_linux:      "794206fbdade4c867bf8886a05b1eb2a0b5e2b874d0f8eab00a7bf3afd8c1366"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "opus"
  depends_on "rtk"

  on_linux do
    depends_on "alsa-lib"
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # symphonia-adapter-libopus bundles libopus by default
    inreplace "Cargo.toml", /^symphonia-adapter-libopus = \{/, "\\0 default-features = false, "

    # Work around arm64 linux runner crashing from fat LTO
    github_arm64_linux = OS.linux? && Hardware::CPU.arm? &&
                         ENV["HOMEBREW_GITHUB_ACTIONS"].present? &&
                         ENV["GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED"].blank?
    if github_arm64_linux
      ENV.deparallelize
      ENV["CARGO_PROFILE_RELEASE_LTO"] = "thin"
    end

    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm").to_s
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s if OS.mac?

    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"opencrabs", "init"

    config = testpath/".opencrabs/config.toml"
    assert_path_exists config
    assert_match "[database]", config.read

    assert_match "Database:", shell_output("#{bin}/opencrabs config")
  end
end
