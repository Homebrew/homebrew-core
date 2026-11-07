class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v3.41.0.tar.gz"
  sha256 "f93510d6c9e68d4692707dd186c227bfbd621b98298a10fb7bb6bdfcb9e3be90"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bd3c08f7e04d76370c4891703963c3f76f89a7809e9395aa1aca4384f35a4035"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4f5e621f393b8e5237b9c94b060a6c620cf53f0d22e9514fc4ae8b589468be54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "845196f6798c0023e12de591ddcd4ded6d0f0d14e4c1c9bc9292050095ebd5b2"
    sha256 cellar: :any,                 arm64_linux:       "5b4a3a48a29bc232bd7e6d71eb01fe05e21e8bdbc9805a49e5532cd1f95b6a95"
    sha256 cellar: :any,                 x86_64_linux:      "83e225f9026b0de9079e244a29e059f8c7efd798960101d7b24a3b8f19989e31"
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
