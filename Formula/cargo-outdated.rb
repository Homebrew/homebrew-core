class CargoOutdated < Formula
  desc "Cargo subcommand for displaying when Rust dependencies are out of date"
  homepage "https://github.com/kbknapp/cargo-outdated"
  url "https://github.com/kbknapp/cargo-outdated/archive/v0.11.1.tar.gz"
  sha256 "2d80f0243d70a3563c48644dd3567519c32a733fb5d20f1161fd5d9f8e6e9146"
  license "MIT"
  head "https://github.com/kbknapp/cargo-outdated.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d9992bcef76c009e18f8a77aa3f6cc457c72bce7d72e078517744ca139b75125"
    sha256 cellar: :any,                 arm64_big_sur:  "c7b4435ef3e709b0eb807a99ae088537ae7133c07181346b3a3e8c254bd02437"
    sha256 cellar: :any,                 monterey:       "185935f62ff6132e75d7f0c6c8e9fdd487e9d488e1546b8471cae090a3f06caf"
    sha256 cellar: :any,                 big_sur:        "227989c4aa9cda780813f0a9ba32d47305a0f9469844897e80ffe5636e1cbd56"
    sha256 cellar: :any,                 catalina:       "946e355c42343a215b9f4927a1a23439d97ac7bb156f38954dcf4c906f635f14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3d25a01a0b6532594534b4d80053b14347e07e5322a0e0b44c102a75bcfe1b1"
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
