class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/v0.7.0.tar.gz"
  sha256 "56b51ef8d52d8b414b5c4001053fa196dc7710fea9b1140171a314bc527a2ea2"
  license "MIT"
  revision 1

  bottle do
    cellar :any
    sha256 "dda337a0b67c8e1b0be8a8718871e72363208f355b2204e1b91f0cb3fd746460" => :big_sur
    sha256 "b06a55109f2992cd06372aebf167c351b106d9e0d7a1fe9b6bc18c1d21abff01" => :arm64_big_sur
    sha256 "6998a3ce2b08aa612b3fa875f368d0fa8012404ef52480292c57d611d176de75" => :catalina
    sha256 "db8fc1ad91e81679e46f49dddb9280b825b17b6ed9762f66a070af52ddee952a" => :mojave
  end

  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@1.1"

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
      EOS

      system bin/"cargo-add", "add", "clap@2", "serde"
      system bin/"cargo-add", "add", "-D", "just@0.8.3"
      manifest = (crate/"Cargo.toml").read

      assert_match /clap = "2"/, manifest
      assert_match /serde = "\d+(?:\.\d+)+"/, manifest
      assert_match /just = "0.8.3"/, manifest

      system bin/"cargo-rm", "rm", "serde"
      manifest = (crate/"Cargo.toml").read

      assert_not_match /serde/, manifest
    end
  end
end
