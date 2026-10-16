class Opencrabs < Formula
  desc "Autonomous, self-improving AI agent in a single Rust binary"
  homepage "https://opencrabs.com"
  url "https://github.com/adolfousier/opencrabs/archive/refs/tags/v0.5.11.tar.gz"
  sha256 "134b7383c6eebf4e636062d5199b210679d846e3f360c3d83812f8f5b520c3eb"
  license "MIT"
  head "https://github.com/adolfousier/opencrabs.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3f40b749a41460de52c1ef94c0009e0d3d5f0119a0efff4947eb2dc422e6fae9"
    sha256 cellar: :any, arm64_tahoe:       "49bc7e856d451a7df45d24c47ab5692993b0b7d1f9464baa9d5a2dbd5c81fdeb"
    sha256 cellar: :any, arm64_sequoia:     "34e5b03c0fb694b11c44d4e0d3595e248b3868f81f83034cb99972bc2b81c37f"
    sha256 cellar: :any, arm64_linux:       "687d3a878122bb7ca5591d7622582b58d35d28299bc48422e7de367e0fe36ede"
    sha256 cellar: :any, x86_64_linux:      "64c7961ec6f0d8b4b334d82ac0304dbdee17aa9e2bd9a842c2f282bf70c25c52"
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
    assert_match "[provider_registry]", config.read

    assert_match "Database:", shell_output("#{bin}/opencrabs config")
  end
end
