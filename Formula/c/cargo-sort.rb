class CargoSort < Formula
  desc "Tool to check that your Cargo.toml dependencies are sorted alphabetically"
  homepage "https://github.com/devinr528/cargo-sort"
  url "https://github.com/DevinR528/cargo-sort/archive/refs/tags/v2.1.5.tar.gz"
  sha256 "40e7d5940538bc5e87aacb0bd9462a342d99d9ab128ccaed62d750f7671498a9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/devinr528/cargo-sort.git", branch: "main"

  bottle do
    manifest_sha256 "93b4f3a4be9660ed190e777bf38bf6d64580ee90d225ee9934220c14b2fd8ea9"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5505a8bb7931266c238fd6ced5736172b02cc3091e158006b10043b81de9f879"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "30aab2122c15cbb66abec118cdec85e8eae82c7abddeb24a700ba3ee81a0b0ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d6ee8c7d171238011d77496abd6ad5237b6eb46d6457f5afc995946354925a50"
    sha256 cellar: :any,                 arm64_linux:       "4a32a546d75455572d6fff171015574212e6dea4edcc3f54051a0a52a9e160e9"
    sha256 cellar: :any,                 x86_64_linux:      "d1eaeb204b429a2f9d7a12dcc18b1a5833fe5a8142525f8efc119552cd2ea965"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    assert_match version.to_s, shell_output("#{bin}/cargo-sort --version")

    mkdir "brewtest" do
      (testpath/"brewtest/Cargo.toml").write <<~TOML
        [package]
        name = "test"
        version = "0.1.0"
        edition = "2018"

        [dependencies]
        c = "0.7.0"
        a = "0.5.0"
        b = "0.6.0"
      TOML

      output = shell_output("#{bin}/cargo-sort --check 2>&1", 1)
      assert_match "Dependencies for brewtest are not sorted", output
    end
  end
end
