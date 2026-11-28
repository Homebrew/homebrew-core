class Opencrabs < Formula
  desc "Autonomous, self-improving AI agent in a single Rust binary"
  homepage "https://opencrabs.com"
  url "https://github.com/opencrabs/opencrabs/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "8d30b8eded77d4d329c253994c2bb5ec1f266ad970929dea744fad9a44524cce"
  license "MIT"
  head "https://github.com/opencrabs/opencrabs.git", branch: "main"

  bottle do
    manifest_sha256 "c10bd4d4bcacea0471d106233e01ba411ddbace10b5605d4022ee7cf4cc7295b"
    sha256 cellar: :any, arm64_golden_gate: "f32f8c75abf62969afb96a83f1243ad4d67de32e7542ebae21c4179588bc1d27"
    sha256 cellar: :any, arm64_tahoe:       "d9ab05d97a2bd4ce46237cd72cf220d3d980f26966f9897e18ec2ddb74b76d9d"
    sha256 cellar: :any, arm64_sequoia:     "983535231c96efc0af25cd84a6bfbc089d620a32382c6f80da9a15f53c079a86"
    sha256 cellar: :any, arm64_linux:       "71bd70626fe40ffdfbfe4597c3bb12db0a5b20afc5aaf832894beb8aaf131305"
    sha256 cellar: :any, x86_64_linux:      "8fc8a24701780c44c0136af8fad7b182cc32d47da0e7ee0d485646a0323e039c"
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
