class CargoOutdated < Formula
  desc "Cargo subcommand for displaying when Rust dependencies are out of date"
  homepage "https://github.com/kbknapp/cargo-outdated"
  url "https://github.com/kbknapp/cargo-outdated/archive/v0.10.2.tar.gz"
  sha256 "0f8a4badebeb98d01808bc811c0e840a261df3d0c6306b05a4a9e926b754fc02"
  license "MIT"
  head "https://github.com/kbknapp/cargo-outdated.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "8e20a7d7500c5c58d454657d0b7b7ac2f251e09938340d9a18519ce1e379dd52"
    sha256 cellar: :any, arm64_big_sur:  "1f8e5e78dac65f29b9d9a07d270dcd424cc3e3ad0d7c7c34224c6edcd3a0817a"
    sha256 cellar: :any, monterey:       "fd847aa5052de2bebf2724d325567968e5c278fe7bc83eb465d16d53925576c6"
    sha256 cellar: :any, big_sur:        "28864dc6c4e102e674ebf0d51a3e0967460502885a1ecb88538729ff4879613b"
    sha256 cellar: :any, catalina:       "bf285ce68e96a08d37ceb0777dcdb586635582f70ceb70e529c49adf7564f847"
    sha256 cellar: :any, mojave:         "328e96693648cd956cbe001f87d527a45cbe4318e3e4f1f2b28d89d44681f852"
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
