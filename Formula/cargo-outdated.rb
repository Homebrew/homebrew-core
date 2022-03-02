class CargoOutdated < Formula
  desc "Cargo subcommand for displaying when Rust dependencies are out of date"
  homepage "https://github.com/kbknapp/cargo-outdated"
  url "https://github.com/kbknapp/cargo-outdated/archive/v0.11.0.tar.gz"
  sha256 "203504d8f7aa6ba633e256b6f9d81162dd1f3ddbf92934ff689060ae80b6b203"
  license "MIT"
  head "https://github.com/kbknapp/cargo-outdated.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1f54e6bca327089d0b837e053c5728b6b59359f675d28ba5f81e5f234c0fe704"
    sha256 cellar: :any,                 arm64_big_sur:  "05d8e69b56e000d198e6ea9fe03cf7abb23069b8e1623110a03e0d34aaba292b"
    sha256 cellar: :any,                 monterey:       "a838afe115ca59326d2d891ea00f0091634f5e3c4584d6259652cb0eb836d367"
    sha256 cellar: :any,                 big_sur:        "4fdeeb537d87bc5bfe4400f1c3ef25ad9466405bedd8b6e203e49280be86bb85"
    sha256 cellar: :any,                 catalina:       "1abe8fd2d8d1bb07f828ffc585dc4c9b495797e728b07e0a418f45bd51b89b8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4a4bbf04585a1cd9b0c52b0aa09c077a61ebd5572be77217634f7201db4b6ee"
  end

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
