class CargoGeiger < Formula
  desc "Detects usage of unsafe Rust in a Rust crate and its dependencies"
  homepage "https://github.com/geiger-rs/cargo-geiger"
  url "https://github.com/geiger-rs/cargo-geiger/archive/refs/tags/cargo-geiger-0.13.0.tar.gz"
  sha256 "02a3999b58e45527932cc9fa60503b3197f011778dc1954909fb5fe9dd168f72"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/geiger-rs/cargo-geiger.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "88ec2b410e24b605256007ac5638b8a5a49d5ffb1a62e60393961e11971a1d42"
    sha256 cellar: :any,                 arm64_sequoia: "51b91185a2d416c65ad628f9b84a5e1612c8e44a5f0418099bb4407d6cf77fcd"
    sha256 cellar: :any,                 arm64_sonoma:  "6a5a514bbee93789316736a19e716ea74bfaa877a8627aa45fe28fc9c9033228"
    sha256 cellar: :any,                 sonoma:        "777ba436a9bb9416bcf1bdd7988a8da9ac1a4b50943990b7dd78f974b070889a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "043847d1967ef34c4e55f3825c3498fa3f919ce919232316323bdcb3e3ed1e18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "991088f8555c7dabbe84f4519d8d4b527d14bc035f6db978da4a605efb9f1145"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "cargo-geiger")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    assert_match version.to_s, shell_output("#{bin}/cargo-geiger --version")

    mkdir "brewtest" do
      (testpath/"brewtest/src/main.rs").write <<~RUST
        fn main() {
            let mut a: u8 = 0;
            let p = &mut a as *mut u8;
            unsafe { *p = 1; }
            println!("{}", a);
        }
      RUST

      (testpath/"brewtest/Cargo.toml").write <<~TOML
        [package]
        name = "test"
        version = "0.1.0"
        edition = "2021"
      TOML

      system "cargo", "build", "--offline"
      assert_match "Metric output format: x/y", shell_output("cargo geiger --offline")
    end

    require "utils/linkage"

    [
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-geiger", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
