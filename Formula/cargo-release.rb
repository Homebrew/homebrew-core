class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://github.com/crate-ci/cargo-release/archive/refs/tags/v0.24.5.tar.gz"
  sha256 "15cf892e78ca1090260ef4d498df1d8936696321b20584050a0f89387b438c08"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "32ac6182b9d748c8bc1280fa8cca07f5c6c167ff4ab85dfe25a0a30292680128"
    sha256 cellar: :any,                 arm64_monterey: "2318e0591acfe3b86c8a57cecb609cdd46f7977af37381e668ebb8cd67fa3050"
    sha256 cellar: :any,                 arm64_big_sur:  "9bfcfbf663a7a4b16ad7c11a1e83e156fd322817d2985fdbda5f443a547d09dc"
    sha256 cellar: :any,                 ventura:        "e4067abfde7b0275e4fa7ea398035819a7a4a760cc3694266700bb929c3347b0"
    sha256 cellar: :any,                 monterey:       "985578325cda3d320c6b1bbd97a5d4ed9e1bdd32aac7227dd8ef9f432cba8a5a"
    sha256 cellar: :any,                 big_sur:        "6a2065f089e19268940efb4787817dd32caac6c9eb905923d90a8e6bd1137009"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ac62bfd2440af055eebcd383c52c493cba13d03968b7741d58a4ba85b045de5"
  end

  depends_on "rust" # uses `cargo` at runtime

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      assert_match "tag = true", shell_output("cargo release config 2>&1").chomp
    end
  end
end
