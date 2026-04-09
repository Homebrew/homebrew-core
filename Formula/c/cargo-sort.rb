class CargoSort < Formula
  desc "Tool to check that your Cargo.toml dependencies are sorted alphabetically"
  homepage "https://github.com/devinr528/cargo-sort"
  url "https://github.com/DevinR528/cargo-sort/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "21681504eca0b1e5d53f321d0ca21db1f72ac6ab11a937c1ddc2be20f6e860b8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/devinr528/cargo-sort.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa5fd190418391f09d477de85f8be63fdbd5964514d3397fe3994408e1023bb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4435739687a48a72712723ac7bb40f30f6b9eaf340687ad1c1b272d38c2a11c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "375aab4a98681e8ea06c0fcb15d900630f9b507ae1743285ebe9deaef1248826"
    sha256 cellar: :any_skip_relocation, sonoma:        "eac3d87e0809e2f792704d1a42237f0f8de2bccc89d9768ef24782d7bd32b6fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "885f2c240406e1a6740ae52d3ee253ebce33948381699592ce9ae371ecc8e679"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c781e6e9fb4ce62a16d5a9bac3fb0fdfd1fde3ba896fd9931be4a9770feca6b"
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
