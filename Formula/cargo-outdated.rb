class CargoOutdated < Formula
  desc "Cargo subcommand for displaying when Rust dependencies are out of date"
  homepage "https://github.com/kbknapp/cargo-outdated"
  url "https://github.com/kbknapp/cargo-outdated/archive/v0.11.0.tar.gz"
  sha256 "203504d8f7aa6ba633e256b6f9d81162dd1f3ddbf92934ff689060ae80b6b203"
  license "MIT"
  head "https://github.com/kbknapp/cargo-outdated.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a1a02a91c18803be32a47359119f65789037400c9225a567c484fb304ac49de3"
    sha256 cellar: :any,                 arm64_big_sur:  "2a03fe15e0b7934985fb9cea65efe32b0b28ac7665d81463f49a29724bdfa507"
    sha256 cellar: :any,                 monterey:       "8a353caa9e7e3237e1c05574151982f0c2a18a86c633dd389292059f05831a04"
    sha256 cellar: :any,                 big_sur:        "5c52e6faa0351dd588b3f7a70320b140af0540ea6cb84cbb25757530c61f3081"
    sha256 cellar: :any,                 catalina:       "42531a5f9b9bde7545cb11447244e2a118b504ecdf6e8030f409da5cd760dac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0415af73396a4b7a6745885a5b5ed3a4f6d3603d7e9ebaf7c3e2af85aa4c27ba"
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
