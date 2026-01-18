class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://github.com/bartolli/codanna"
  url "https://github.com/bartolli/codanna/archive/refs/tags/v0.9.13.tar.gz"
  sha256 "76798813e16c1a21c086dab40c0b259faf248ac6ba78f46061f02ffb1d7ab051"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ea2eddb7ce0f0ed15b9bc97ac9dc5a66607148c63c6239f91e6861b8061fab08"
    sha256 cellar: :any,                 arm64_sequoia: "90a52d481f9edc8b931e083eadaef90a383278a44318f3fe5ba947b8c39802d7"
    sha256 cellar: :any,                 arm64_sonoma:  "91ebe83f255754a71ca76e89a84ddb13a981843311d16703887ebb11d9cf253a"
    sha256 cellar: :any,                 sonoma:        "ce6be1ec72eda4f2b8c6cb55000411fea3674346ce59756e309e0d09696db5f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db1b0dc118d6ff37d6720eeda48a3ed258ed4f2a060f63fb709e5b626d085509"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3bb39d0e3860198167c3e6a42572ba7036e5898c111d894455a3ab679b1fc25"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args, "--all-features"
  end

  test do
    system bin/"codanna", "init"
    assert_path_exists testpath/".codanna"
  end
end
