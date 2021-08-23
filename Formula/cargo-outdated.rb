class CargoOutdated < Formula
  desc "Cargo subcommand for displaying when Rust dependencies are out of date"
  homepage "https://github.com/kbknapp/cargo-outdated"
  url "https://github.com/kbknapp/cargo-outdated/archive/v0.9.17.tar.gz"
  sha256 "9311409ce07bad0883439fdba4bfb160e8d0c7a63d84e45dc0c71fbeb5ac673a"
  license "MIT"
  head "https://github.com/kbknapp/cargo-outdated.git", branch: "master"

  depends_on "libgit2"
  depends_on "openssl@1.1"
  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [lib]
        path = "lib.rs"

        [dependencies]
        libc = "0.1"
      EOS

      (crate/"lib.rs").write "use libc;"

      output = shell_output("cargo outdated 2>&1")
      # libc 0.1 is outdated
      assert_match "libc", output
    end
  end
end
