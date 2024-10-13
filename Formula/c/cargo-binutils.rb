class CargoBinutils < Formula
  desc "Cargo subcommands to invoke the LLVM tools shipped with the Rust toolchain"
  homepage "https://github.com/rust-embedded/cargo-binutils"
  url "https://github.com/rust-embedded/cargo-binutils/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "431fb12a47fafcb7047d41bdf4a4c9b77bea56856e0ef65c12c40f5fcb15f98f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rust-embedded/cargo-binutils.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6367b34d9c10ac1d5172697f7b34ce9b448960084c1584ad1d6b0f19e40b8ee6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54c3cd2a10fc84faf03c3dfe9ca8ffeef01811c0a264473430c202b624672539"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73469ea42c9f0ee96fbd51f1b08f356104a0a3114a7a8428c9cb659fd636654f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9440dcd36d4c6335d6503aa36766cd83692203b16c36ff184ef8337bb360b65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea6191a3486774767591b8da025736c7911618aa5d825fc93372bad6a15f4d41"
    sha256 cellar: :any_skip_relocation, sonoma:         "346badf808aff5c0a49a830a8fe2169ad509c9ea10869d94ed513b7e4626d9fa"
    sha256 cellar: :any_skip_relocation, ventura:        "06566f6a3668b2ee04e4caada6d092c2be827d17c94d4e3d9dc78b860ae66f24"
    sha256 cellar: :any_skip_relocation, monterey:       "f723cc7c2965cf903f9bb3e0eb825b4d07fcb343f1c4ab13fd8b9042708dd82d"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbffb949c95924792a8467de511a274b2f0243087ebc3caed26f8fce8ae536d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "573501160232330f4511aa8928446522801ade98223b640b3202c8ec0871217c"
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
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"
    system "rustup", "component", "add", "llvm-tools-preview"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~EOS
        fn main() {
          println!("Hello BrewTestBot!");
        }
      EOS
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
        license = "MIT"
      EOS

      expected = if OS.mac?
        "__TEXT\t__DATA\t__OBJC\tothers\tdec\thex"
      else
        "text\t   data\t    bss\t    dec\t    hex"
      end
      assert_match expected, shell_output("cargo size --release")

      expected = if OS.mac?
        "T _main"
      else
        "T main"
      end
      assert_match expected, shell_output("cargo nm --release")
    end
  end
end
