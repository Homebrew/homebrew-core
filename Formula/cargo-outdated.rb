class CargoOutdated < Formula
  desc "Cargo subcommand for displaying when Rust dependencies are out of date"
  homepage "https://github.com/kbknapp/cargo-outdated"
  url "https://github.com/kbknapp/cargo-outdated/archive/v0.11.1.tar.gz"
  sha256 "2d80f0243d70a3563c48644dd3567519c32a733fb5d20f1161fd5d9f8e6e9146"
  license "MIT"
  revision 1
  head "https://github.com/kbknapp/cargo-outdated.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a7200baa0f4f7d6cf7c070cb5534b9b1b006705c58182a063d54d896a8866fca"
    sha256 cellar: :any,                 arm64_big_sur:  "f0dc694fe1acfea814020900dfffb14f8d2e303047b6a822922791447c541f48"
    sha256 cellar: :any,                 monterey:       "875fce52ee9f0046a7019fda286baaf41514c4ad9c203703b752d2506da46937"
    sha256 cellar: :any,                 big_sur:        "f65f250655560261e038b002d0844b9012cb769fb2fcde3cf9d72e0d7a9ce9c9"
    sha256 cellar: :any,                 catalina:       "ea093812c8421f5feba5b7af9b7abc9cd821d0aae6bcb376d7277ceed76ff051"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac2a43a2c023f9c8734e7a8f7bd7de266b39d83e17b6baa5a8ff715f5f67806b"
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
