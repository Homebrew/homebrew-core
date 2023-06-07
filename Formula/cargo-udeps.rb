class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https://github.com/est31/cargo-udeps"
  url "https://github.com/est31/cargo-udeps/archive/refs/tags/v0.1.40.tar.gz"
  sha256 "7122f08b9dac152c6dddacd2610aa973807037f2a2f1d9042de4bcf17d344471"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a5af2b20a63790af8fad905b655967057eb566c75c777a941411ff6129331766"
    sha256 cellar: :any,                 arm64_monterey: "2def009e9344aee7da3438a9a0299e302768126f9ad2ff832b6368f0f9345fc5"
    sha256 cellar: :any,                 arm64_big_sur:  "e3f87f83e8f5e6ffbe51e69be0308d681a7a3e92a7a5c5db55bdd7ad50aeb2bf"
    sha256 cellar: :any,                 ventura:        "479e6855fdc5fe106f683c72d57c6ccfa050a38986cdb615ff54f18a5dbeab06"
    sha256 cellar: :any,                 monterey:       "22c26be0ec375d8dbf0ac6366f39c093f11d47604f1c7ff5cdd8e17155fc5466"
    sha256 cellar: :any,                 big_sur:        "951b5293fbc9b7cc091ccd7078badc433039911f8862c3f7f94cbcd09295585f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40f97acc5f1d9746d17a0e4ddf080876a18823443a1575df6689bd914028ba25"
  end

  depends_on "rust" => [:build, :test]
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write "// Dummy file"
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [dependencies]
        clap = "3"
      EOS

      output = shell_output("cargo udeps 2>&1", 101)
      # `cargo udeps` can be installed on Rust stable, but only runs with cargo with `cargo +nightly udeps`
      assert_match "error: the option `Z` is only accepted on the nightly compiler", output
    end
  end
end
