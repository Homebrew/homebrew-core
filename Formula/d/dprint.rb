class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/refs/tags/0.48.0.tar.gz"
  sha256 "ef4c150c31dc3da7cecb8a192722784778499fbfc297b620b636ce088d6a6d0e"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d7f537231482b8eeb8542ff46256cb44cbeb20cba18d33ec06dd4544bb3b125"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fe9111aa55a00563a99857d14229ab2432e1a63140c02d66c8ade5ac5112c72"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cb1b10dbea113351df8653ee40188a3bd87550540c5c99df4f0f00d73864c677"
    sha256 cellar: :any_skip_relocation, sonoma:        "39f058f2d96f2635aa936db41f0a1bec6312dc5418040092b30e4d419341a542"
    sha256 cellar: :any_skip_relocation, ventura:       "1c92708f4d31eaff09a622dbbce5f43a5a3848e259f8914eb8b2c30696e641b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5ab8cbdab295ac93d4b9f1d7a23b3400cc0de20233737493bda3aa89d3a764f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/dprint")

    generate_completions_from_executable(bin/"dprint", "completions")
  end

  test do
    (testpath/"dprint.json").write <<~JSON
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
    JSON

    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"dprint", "fmt", testpath/"test.js"
    assert_match "const arr = [1, 2];", File.read(testpath/"test.js")

    assert_match "dprint #{version}", shell_output("#{bin}/dprint --version")
  end
end
