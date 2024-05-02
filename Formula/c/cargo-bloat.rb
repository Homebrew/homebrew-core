class CargoBloat < Formula
  desc "Find out what takes most of the space in your executable"
  homepage "https://github.com/RazrFalcon/cargo-bloat"
  url "https://github.com/RazrFalcon/cargo-bloat/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "999b6b982b6907d92e089d1283626fedc578473f5a6bc360a9dad869d3079597"
  license "MIT"
  head "https://github.com/RazrFalcon/cargo-bloat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8fe2e33df2b107b8e6a2285ff36858d06c7fc131db551f7a7a7006d88a99a8be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb6e18f5c298bc3dcea83df0e06ef3add61b0afc022944f05475fbe1b943ef9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc33b90b76d4e8652ac0d3477fddcabb4fb635d63b6c2a79955b9023bb98fd5a"
    sha256 cellar: :any_skip_relocation, sonoma:         "8517336ed7446d54dd6f462448ce5e9f90b05ca589428c0b32d59d14ed6703fb"
    sha256 cellar: :any_skip_relocation, ventura:        "32d44cb5878e1f67d2c01ce21f1ba58a65a61d526e14da933315c9a7f77cac60"
    sha256 cellar: :any_skip_relocation, monterey:       "b77287ceac75e174e10c7c3c9c2eec865e442a8bdd8df01915e11e163b2644e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c24b7e0cbbd2549eb87089768638e0ea4c42c42a3955c080e5cabcb899dd443b"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin/"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      output = shell_output("#{bin}/cargo-bloat --release -n 10 2>&1", 1)
      assert_match "Error: can be run only via `cargo bloat`", output
      output = shell_output("cargo bloat --release -n 10 2>&1")
      assert_match "Analyzing target/release/hello_world", output
    end
  end
end
