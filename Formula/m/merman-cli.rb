class MermanCli < Formula
  desc "Mermaid.js, but headless, in Rust"
  homepage "https://frankorz.com/merman/"
  url "https://github.com/Latias94/merman/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "4a213990d7b329e1ddb7de5710cc4530a505f967d148afd54b9d3741ca15f3b9"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "33db93766532ad512ac4cbff7cecbfe92b887435d92435ab4f74c2e4aecba097"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "85ad9647499eafcbda591085b2900db64d2e9479fe12de4fcdc76e5cbc594c1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bbf7efb78e6d69e48ab5a06f37f44b317fed71c71b72331011a224a51097175c"
    sha256 cellar: :any,                 arm64_linux:       "8094a5a19a9a7955543adaf93a94e29808624e34118bc6a79eb10cd60e5577d6"
    sha256 cellar: :any,                 x86_64_linux:      "2f09d666182b3b64be5d1ea8f169c876fa690ee002f716301a435b1ad1782122"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/merman-cli")

    generate_completions_from_executable(bin/"merman-cli", "completion", shells: [:bash, :zsh, :fish, :pwsh])
    man1.install Dir["crates/merman-cli/assets/man/*.1"]
  end

  test do
    mermaid = <<~MMD
      flowchart TD
        A[Start] --> B{Decision}
        B -->|Yes| C[Do thing]
        B -->|No| D[Do other thing]
    MMD
    testdata = testpath/"sample.mmd"
    testdata.write(mermaid)
    assert_match "svg", shell_output("#{bin}/merman-cli render --format svg --output - #{testdata}")
  end
end
