class CargoAuditable < Formula
  desc "Make production Rust binaries auditable"
  homepage "https://github.com/rust-secure-code/cargo-auditable"
  url "https://github.com/rust-secure-code/cargo-auditable/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "091dc954c09408a9a2bdf1b01fa34f3e4bf7a7621966d2f4c4d5fc689a3baaf4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rust-secure-code/cargo-auditable.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e1d23238c3b31a6084aab88296f36318928d92b6228c3fc961db2323a0ba78c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d41197793c5a2d1ce91b79fe73fdecb43cd3b6c6b18a70fe03f1b49fc0a83c55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0917467a0e24accccdc96c275fb0e7391b6259a318c3f92969c3bf67f060c140"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f33e9bfb8c93a6a7d791f71e065c2f9e637b7ec509239a73707d15e5a97bfbb1"
    sha256 cellar: :any_skip_relocation, sonoma:         "e614b1006ee6add5d104a6efc171ef5c314221ae8988a01eedcbef1e34fc78f0"
    sha256 cellar: :any_skip_relocation, ventura:        "29bad4be60aa150cd04578d81d53ff18526b62c3bfed7fb12bb8816b755b6070"
    sha256 cellar: :any_skip_relocation, monterey:       "ecc1f87a0d5ffb886dcd9529efdde947a3d74620fdefbb7eb0825f4fbc772d76"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3be96740b3423596798aee06c96b83e3668b3583294cfe0b0d40bd84d810783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e770fd3d8ce7ee24020d2eda3c2fc6e9c142558a96b2527e12315eda28c8dee"
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
