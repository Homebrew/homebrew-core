class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v3.39.0.tar.gz"
  sha256 "ac9f3d853b06c1d9098861a22117b9e90b6abb823ff59a93ccbb612f56ea0b19"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f9a330db300f8e0f9974fa55f78c3452b46faf698b7812f1c421dc2eb780f4cd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8d353548d8fd053b3ac553e6aca94c5783118c04c2a02c2484f6a3f881abf00d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f160666c34643507b110910e0f3466f9ab4e565f658539cd8072eab68656a54c"
    sha256 cellar: :any,                 arm64_linux:       "053a51ddbc6161950df0ab26cea6837bbf40fd2f8ca3aa154dac2cc641735a14"
    sha256 cellar: :any,                 x86_64_linux:      "a4a92af2965e1428d43a12903776dc7b6fd34085369a033304bea44b243afc6f"
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
