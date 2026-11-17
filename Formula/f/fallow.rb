class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v3.43.2.tar.gz"
  sha256 "771644aa95d7df0ea6deef3e55c0610205d30190af58e976c64ed881e823d49a"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ef1ca43126aa407db328c7bfad9b5de11cdcd5d41740de0efcebe3453bf01620"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c1f2e13f7e084ef65329492f717c85056ee31914995fa3bd7bc28c2ca271beaf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dc456495bb9699be891c67122c7dc7888823c9693c316036b434075b0f950ff3"
    sha256 cellar: :any,                 arm64_linux:       "c4656e8caccac5a0d7315755960d4fbafacade4e247d8476a7143cb885edd687"
    sha256 cellar: :any,                 x86_64_linux:      "18bc1ad3b165a5f0e3e95b53239d4914d8c58589233bf2273ff17349ffff1a57"
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
