class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v3.27.0.tar.gz"
  sha256 "c9cfd746e7b27882a0b3a4aecd24052c900f589393e54cbfef9e2eaa32e77b41"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b5f33522a3bc61d0c481defed568698190e91d09ce6194ca4932a95bfde7f3a6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "376a8220ae71fb4f02aaa26db9dd0da95f05b8288b3d6ee6d96a44d183a76209"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "75e6e6ef7992926f5080d7de86a872f9fb3642884b9d510b4ac8a31b2bee7cd4"
    sha256 cellar: :any,                 arm64_linux:       "e7aefaa5c0cd51dcf1421d8a5ca376db580a6837bf1c86a14431fb6ad31e06e2"
    sha256 cellar: :any,                 x86_64_linux:      "50449d09f5d2a436bb146bebc558a3f97b8287a4128a9a27b023eba7a781393e"
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
