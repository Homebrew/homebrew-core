class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "fe7129d6ea0e3325a5c11a6924681424cd61bac5e21794b3f9eb239a6fa701ac"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73d1f49870d0086278deeb66ee836fa4297af3882d0710e885ab5f8aac487395"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed3dddcc5e2e7a5738f99d04ecfda68d27206e0fed8c9938c8b630d32aae20fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b511ac491ec42af9bcf4b488eea0fa14d596d91ff3e93055980b8737bf135e47"
    sha256 cellar: :any_skip_relocation, sonoma:        "180b4455ec3344747aa660bc8ca834b9271acd40a68a5d0f49ac057ffcc28ed5"
    sha256 cellar: :any,                 arm64_linux:   "6246debd9ea6f22d417405a16a1d3d992a65aca209640194ba12e095c46084dc"
    sha256 cellar: :any,                 x86_64_linux:  "70fdd58df4e54372367c0303005942a05c7814be6b5f61ba7c3a3feea5cd2c5d"
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
