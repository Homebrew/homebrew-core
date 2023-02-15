class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.34.5.tar.gz"
  sha256 "e0980db9f4003823b99b1b9a17f460f71ce55bffaddfba80c5f00e0492746e00"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b9ea7ec7bc667fe2b19701cfaface9b95bcd90b977945ee9d52a718981018ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65b1a5c886ef8df1d4a4a95334ee15c3fd57def60f463a4be5b783a644490ae7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d942ff599de786f0faf4913daeacae3d9403ae9672f51023a3b4a12ecec2d6b"
    sha256 cellar: :any_skip_relocation, ventura:        "5646933e52bf0c196b0ea05e02eee26a8fec772845159c875f401eb0131a9347"
    sha256 cellar: :any_skip_relocation, monterey:       "788f3e1b2e0ef543fe755d2df27d66a34a3ede4b1d1e0667f0c07e2b3412e71b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e2a7c3955a80414b4899adbb8570480182946e4583ad86958eeb20aaa977e05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe770d689f12e9d553f03cb442ef6757e8f3c5fc570ab71ae8ae1b7a73422885"
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
