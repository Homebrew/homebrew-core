class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v3.42.0.tar.gz"
  sha256 "da5bcdc900954d55f6c7a182733489d5ea3dd9011c5c741ed7349d34e062bff8"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aa7aa11b962b92a9ed0d3db078703a88d1a91e631cc3475a7dcd4a3edff4513c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "511719483fb473c9f80ee3c6bd1af77e6d26aa68646f9be0a6ed70d6a500d5a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5a2906961a76485d0dcc1f895ebbf706f4471cd1a99d56734af59739b4b8d7fb"
    sha256 cellar: :any,                 arm64_linux:       "7c117bb8fca8c4cede0df64362efcb473269fa0186651afc82b2345ccd7029c7"
    sha256 cellar: :any,                 x86_64_linux:      "71ef5b73fbb1c826e1c20e53157118b32865de17af2cf2a95fd5dc7ef813ee88"
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
