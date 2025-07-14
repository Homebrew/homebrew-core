class CargoPublicApi < Formula
  desc "List and diff the public API of Rust library crates"
  homepage "https://github.com/cargo-public-api/cargo-public-api"
  url "https://github.com/cargo-public-api/cargo-public-api/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "f212305aa341cb4d986d6531b25bc50f7cd3134c0ba6417f484e82f034c26a77"
  license "MIT"
  head "https://github.com/cargo-public-api/cargo-public-api.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bd88051e40ba19b5f3aa60658fb18a07074d45df7de7883c510f47cfb8c2982"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f331d9767a7c0c9f8692d19bcb453498659b35d724abfca871381543fd4247ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f032fd574bdccefaab09926bd0fa6f465aee5f6aaf9890cf87ff897d7f32d29"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec8cbe07ee55b6b5cde950e77543273501341c19fe897e700d6190da3250e361"
    sha256 cellar: :any_skip_relocation, ventura:       "bcda176c0ac5bebe13a8397a9ab985128cf3659d079035f3d2a3cef398a7c750"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "104cebcf566589d9238ccee802b1410bd0456b7eeb4b52b3043b5560988aa9e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f77a29318de47bec2fea19da1a4aefa4b73157005c9837defb648977fa4ba10"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-public-api")

    generate_completions_from_executable(bin/"cargo-public-api", "completions")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"
    system "rustup", "toolchain", "install", "nightly"

    (testpath/"Cargo.toml").write <<~TOML
      [package]
      name = "test_package"
      version = "0.1.0"
      edition = "2021"
    TOML

    (testpath/"src/lib.rs").write <<~RUST
      pub fn public_function() -> i32 {
        42
      }
    RUST

    output = shell_output("#{bin}/cargo-public-api diff")
    assert_match "Added items to the public API", output

    assert_match version.to_s, shell_output("#{bin}/cargo-public-api --version")
  end
end
