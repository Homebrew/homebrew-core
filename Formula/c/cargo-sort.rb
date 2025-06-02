class CargoSort < Formula
  desc "Tool to check that your Cargo.toml dependencies are sorted alphabetically"
  homepage "https://github.com/devinr528/cargo-sort"
  url "https://github.com/DevinR528/cargo-sort/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "1e345b7ce5e88b347895e602757c344f8a996700a34dd367d8ad35728ebb846b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/devinr528/cargo-sort.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62b987eaf83d9abfa459ad7b89b3bf3fd622b99b179f0ba472b9708543a4c938"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d424c55d557d82be49dcb3c3f300405b3b5d80e0fef403a465af864d508e4d48"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49803c11c02f3fd6b857e977a4133b1ce131d7b1ada07c9666065882d4749422"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2cfc77ca9bbfdf53b8f1eb03a88d41379bf4fd1985d3c4450a1879b6596e1f6"
    sha256 cellar: :any_skip_relocation, ventura:       "d2339c88c6751fc6167b6570b4d2c09912f70e385c8fb7db9c08459892b018f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cf954a174829ca3a76871682c76f0a8a39583ac3a86cf7ace9b3341a7d01d3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "816e7ed9f55591b73663162de5bd7a1b514c01ce3ccc7cfca49b6e67a1f9e793"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
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
