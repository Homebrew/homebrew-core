class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/v0.9.0.tar.gz"
  sha256 "96c231b30339b1a05444c8faa036be84ecbb7f8eaead95c77de9a05f0c190b64"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7d091fde5db86f4ba07d5423e04ef2f24737b8bd6f512c55dfad03e7f3cec7d6"
    sha256 cellar: :any,                 arm64_big_sur:  "a2cb92cd7df66d900aca7882be1909c16e62c18d1aa0564709198b4c5a7518c5"
    sha256 cellar: :any,                 monterey:       "65d631656dc18e86b89cecaed45e7387a42c65266583dbf3601d52b042f297b0"
    sha256 cellar: :any,                 big_sur:        "3630883c3530a75e043beab6ae521eef02a1a08db072a0886d990612570e6ad6"
    sha256 cellar: :any,                 catalina:       "fb5aa5d30c28e9b6a3d52e4c35cca9bf793e563aed8d5fd6c6dc10c0abd354ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9250ab952edf08068b0a3761ba093212462268fc32c0b559bda434df12e346d8"
  end

  depends_on "libgit2"
  depends_on "openssl@1.1"
  depends_on "rust" # uses `cargo` at runtime

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
      EOS

      system bin/"cargo-add", "add", "clap@2", "serde"
      system bin/"cargo-add", "add", "-D", "just@0.8.3"
      manifest = (crate/"Cargo.toml").read

      assert_match 'clap = "2"', manifest
      assert_match(/serde = "\d+(?:\.\d+)+"/, manifest)
      assert_match 'just = "0.8.3"', manifest

      system bin/"cargo-rm", "rm", "serde"
      manifest = (crate/"Cargo.toml").read

      refute_match(/serde/, manifest)
    end
  end
end
