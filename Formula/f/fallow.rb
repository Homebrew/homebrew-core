class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v3.40.0.tar.gz"
  sha256 "9a659333b4ff4121b62e96d515aa17bdd1f6c138e05aadef00979ddb006f95be"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "46e3fa1a6c10b3a1fabdadfd5e7b93b52cd1674379b0d792eb9476e4601c7e24"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2fb12bb653febb997ec08e9c104aa64853c5a6835ce1750b52d824a26229971d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "18dbe06de5ce4ba81f82fbdc1ee473f9b625b530de75d121ec5bf8aefa277900"
    sha256 cellar: :any,                 arm64_linux:       "65ada37f2829ab94a149b939f44cd20283dd572bf2d2ea794e0ae7ff59dfa44a"
    sha256 cellar: :any,                 x86_64_linux:      "80c590b431dde5362e2f67cae98ec2996c1ec98a8f9513f82a13ea5f6bffcb78"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
