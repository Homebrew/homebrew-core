class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/v0.8.0.tar.gz"
  sha256 "4a08e914c17204cb3ab303b62362ca30d44cf457b3b1d7bde117b8ab4cb2fa64"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "89c3c054b982aaa72718173a5a21c91987d1aa09adc7415b20e56b3dd19caed9"
    sha256 cellar: :any,                 arm64_big_sur:  "07774b6873981705e9d7272aa4503ee9adaa23f412c9618339601b511fc1b035"
    sha256 cellar: :any,                 monterey:       "6643b77a7f85e9e72e9a75f96b269e509889666d0dd0ca25cfd9ada4c09ad1fd"
    sha256 cellar: :any,                 big_sur:        "229d3a9bcb2d7a4c8969234b65ffdad50d768de2cef507e8323be69433f708fd"
    sha256 cellar: :any,                 catalina:       "8bc8ad260d65f9c236b20d162cf1ff041eb68d6c809a242a1fcc5d87d75bc749"
    sha256 cellar: :any,                 mojave:         "b73bdaca55892f47f5dba3ac1107c7dfc8ab64404be70aad843aa9b818756068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e589bf236d88350989b71f09b6ae0b2d8144de55109bceb1af0fd872bf93b6fc"
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
