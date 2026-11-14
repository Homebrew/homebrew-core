class Opencrabs < Formula
  desc "Autonomous, self-improving AI agent in a single Rust binary"
  homepage "https://opencrabs.com"
  url "https://github.com/opencrabs/opencrabs/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "41da3faafe9579f884e9ee20961436cfe35fc6048a3baf1614fbc346a89746b2"
  license "MIT"
  head "https://github.com/opencrabs/opencrabs.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7a7b24f312e4f1fd7e1bca0f4e48bc8a2a12b205777083a636b518e9f32ce58a"
    sha256 cellar: :any, arm64_tahoe:       "cb0691fa8868e779759b6d354cb889c8daf15592ac1c4807fb2169c5f7f6d618"
    sha256 cellar: :any, arm64_sequoia:     "dcecbecb88fe825014a4b8a599996c782f628439c5ca3f2cf04736a8d30cd370"
    sha256 cellar: :any, arm64_linux:       "74216095de003446592a3ada24dc7db0bed1ca6c9bdafae244d0c08253641f5c"
    sha256 cellar: :any, x86_64_linux:      "1dc883085b278fde35a323d20db1332f7fb1cb31dba2de57f1eaf3e74acb401d"
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
