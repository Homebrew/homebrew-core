class CargoAuditable < Formula
  desc "Make production Rust binaries auditable"
  homepage "https://github.com/rust-secure-code/cargo-auditable"
  url "https://github.com/rust-secure-code/cargo-auditable/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "b1c1455b5917d57d4beb3f9bf845059c2d701a034a060b908c7127e29e9b94f3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rust-secure-code/cargo-auditable.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc5be23ef3c7965701d9e289e2273f61d48f979ebf1ab4915eb03009a5a864b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72ad7a7e74cf01a6c4f6c9a67389969cc5de58100b3f42d6244e8af596e8b358"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13304aa02cd9a81cbc60a36e5603dc94aa74949e382825e9706e00dd7b2bd3b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "747ea5a66ad9205fa2841862fd8f261d5a2554e6712a3165fe46488dc434e750"
    sha256 cellar: :any_skip_relocation, ventura:        "4c884ec5c8d25ace715e771fe841368d012aa04529740241acb8e14fae85e955"
    sha256 cellar: :any_skip_relocation, monterey:       "61c1c878c3150a1bdd296755eb49ea1b08a616d0656f4ba1000d5b8251b45340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f26149a719fe7e605d1beb6e6a96fb41d997bfb48431d1de5d0a2d042224ae6"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-auditable")
    man1.install "cargo-auditable/cargo-auditable.1"
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin/"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

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

      system "cargo", "auditable", "build", "--release"
      assert_predicate crate/"target/release/demo-crate", :exist?
      output = shell_output("./target/release/demo-crate")
      assert_match "Hello BrewTestBot!", output
    end
  end
end
