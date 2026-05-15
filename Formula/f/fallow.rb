class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v2.74.0.tar.gz"
  sha256 "931d0879bb4704b6dbdcf3e48cec70a9373b4ddeb4bee9ae3a53c213fda198dc"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9667fb66d5176b965536f877487d531b5d20fc5f3f4d6c906d1771ec1b05d92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0da36a226ea839a619fc1570e4eb7efd681e6404aaa6a2a78ddd0e265c81a88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0980b32505a3ac8207a922e7a8bc10690a8111c9cfa0ce554c5272f63d8c75a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba7864131badb34df74c71487f4de3e23edc2dfd6ab8eb820e8e41136f5a7e6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a02cbc27d10be52b21d85b592f2bf222aa914d43b62ed5925b39fac82240889f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d026d0efb9172d64b65f558423b379bae6a479af4001582fd14a21dd54b2c2e2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "scripts": {
          "start": "node src/index.js"
        },
        "dependencies": {}
      }
    JSON

    (testpath/"node_modules").mkpath
    (testpath/"src").mkpath
    (testpath/"src/index.js").write <<~JS
      export const used = 1;
      console.log(used);
    JS
    (testpath/"src/unused.js").write <<~JS
      export const unused = 1;
    JS

    system "git", "init", "-q"

    output = JSON.parse(shell_output("#{bin}/fallow --format json --quiet --no-cache"))
    assert_equal 1, output.dig("check", "summary", "unused_files")
    assert_kind_of Hash, output.fetch("dupes")
    assert_kind_of Numeric, output.dig("health", "vital_signs", "dead_file_pct")
    assert_match version.to_s, shell_output("#{bin}/fallow --version")
  end
end
