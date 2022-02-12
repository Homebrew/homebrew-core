class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.22.2.tar.gz"
  sha256 "417790567927c3e0c3cb21592002a15f22bb34fc2202e89a6af6ace567ff1709"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3521bc090f02742943e103bf73c79e12517d5242e4165a63c96e0ca829d5a509"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04a25fe52b321558c7f8bb97a2860201ffa854869a6863132152e97cc1ba71d3"
    sha256 cellar: :any_skip_relocation, monterey:       "25f8cd062e7fc6b83a4561449f394116083e21d619b477d00c776e7bfa4cb6e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c6741c2dd439d8f04c4dd137f1eca894a2b3bb51120f8d46a376aff2c69610e"
    sha256 cellar: :any_skip_relocation, catalina:       "13528400657bc0f8c1ecc69b6b1c880048ad11feff2a99f1eb66a5420be30b4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd5c3004f179d5d069a78265f33c14a01a081dcc4129818157a16012e6f2f247"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/dprint")
  end

  test do
    (testpath/"dprint.json").write <<~EOS
      {
        "$schema": "https://dprint.dev/schemas/v0.json",
        "projectType": "openSource",
        "incremental": true,
        "typescript": {
        },
        "json": {
        },
        "markdown": {
        },
        "rustfmt": {
        },
        "includes": ["**/*.{ts,tsx,js,jsx,json,md,rs}"],
        "excludes": [
          "**/node_modules",
          "**/*-lock.json",
          "**/target"
        ],
        "plugins": [
          "https://plugins.dprint.dev/typescript-0.44.1.wasm",
          "https://plugins.dprint.dev/json-0.7.2.wasm",
          "https://plugins.dprint.dev/markdown-0.4.3.wasm",
          "https://plugins.dprint.dev/rustfmt-0.3.0.wasm"
        ]
      }
    EOS

    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"dprint", "fmt", testpath/"test.js"
    assert_match "const arr = [1, 2];", File.read(testpath/"test.js")

    assert_match "dprint #{version}", shell_output("#{bin}/dprint --version")
  end
end
