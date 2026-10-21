class Opencrabs < Formula
  desc "Autonomous, self-improving AI agent in a single Rust binary"
  homepage "https://opencrabs.com"
  license "MIT"
  head "https://github.com/opencrabs/opencrabs.git", branch: "main"

  stable do
    url "https://github.com/opencrabs/opencrabs/archive/refs/tags/v0.5.11.tar.gz"
    sha256 "134b7383c6eebf4e636062d5199b210679d846e3f360c3d83812f8f5b520c3eb"

    # Fix `opencrabs init` failing on a fresh install
    patch do
      url "https://github.com/opencrabs/opencrabs/commit/09f25a468cdd16b5f61519468a8fe6a32e6f820a.patch?full_index=1"
      sha256 "0e01a74cea9782a3078f1c91d324979dd0c733b37ed1c2c8e250ba2f96bafab5"
      type :backport
      resolves "https://github.com/opencrabs/opencrabs/issues/2093"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5a799b87b2512a8bbd778c9774a5d72ba79b204ae789e1e2d558d99ab932d788"
    sha256 cellar: :any, arm64_tahoe:       "78dcbb23717e6cb3598003bd1a2f0286d89a83330e6dd75634303ea26f8c2ef9"
    sha256 cellar: :any, arm64_sequoia:     "daabaf4dbb06177797de174255597c91a3e156f8cdbac916b5e047f95092fd4b"
    sha256 cellar: :any, arm64_linux:       "4ea6bb8134b7f193d10435759675c791d1a2c302b08c28005d39b907348ac6f5"
    sha256 cellar: :any, x86_64_linux:      "e22dc176bba836ce302b924746c78832020e2a29c6842676784240298c662626"
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
