class CargoAuditable < Formula
  desc "Make production Rust binaries auditable"
  homepage "https://github.com/rust-secure-code/cargo-auditable"
  url "https://github.com/rust-secure-code/cargo-auditable/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "3e3f4134d81b47277d34c44bc1169c9b0356612977651f8e98e2ba1a470b69a2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rust-secure-code/cargo-auditable.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "49acadb848d653c214a3a266a9480f556bb2f105172c5c4fd0ab2b932a8bdbdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "daa0ebf98a6d2f0ad0b5efd539e019f97e99906031e2086e6bfb7a1b7f8f510e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86a1584f39b8240505f34461d6fbc3b4e00c0a8216d323c37fe819b99e670c6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14e054bd291ca7775ff27020e04cdaa1c5a12882dda873b5255e4d6919dee761"
    sha256 cellar: :any_skip_relocation, sonoma:         "01c1feb99c94e58ce2d46d39efb512945ea13a9922bb2b9fba032ee8667e2f38"
    sha256 cellar: :any_skip_relocation, ventura:        "df4b5e2d0ac6d4867f0442ce9c547d31ca41cbb65f6c00cde09376d1d0421911"
    sha256 cellar: :any_skip_relocation, monterey:       "879f0a4d5db1b78e6c47cfa3b63e364b9a4865c5518828bbb2a91f9a16745f8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96e9f6c04bd5c980ebd7c4e686b12f9e5d4f6cbf8eae9e9bf1744b3f39f6ffd5"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-auditable")
    man1.install "cargo-auditable/cargo-auditable.1"
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

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
