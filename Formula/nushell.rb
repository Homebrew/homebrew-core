class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.70.0.tar.gz"
  sha256 "315d6f9723c9b036bb0ba268c236f84ba7fc3e3fc36be8e1c45f02dea1b077c4"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9dd26b31c811dcdd8ce391a3ddc6b3cdc01eb3df3b5230eb07e6567c2f23e8a0"
    sha256 cellar: :any,                 arm64_big_sur:  "ce70ac108d515ac6591c096f045b3336cbb67025c9fe61bd83f3481ea6478a70"
    sha256 cellar: :any,                 monterey:       "8dd92379697011bfa44d5a88d73092832b1a282ee3bec8fc2e0b1abdb2addcf2"
    sha256 cellar: :any,                 big_sur:        "aaaa4193a33654f214e8ca562c3fd5f0e6e7afca5e35eaffef4c6722ab118288"
    sha256 cellar: :any,                 catalina:       "e6236f4808c42f9d252746ec265464ff3bb49b5d979f4c5f89144c15367ece51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "560b9e8b7a44ba954d37e26a96eb5a4a6d91896249be67518dafc775b1bf26f9"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", "--features", "extra", *std_cargo_args

    buildpath.glob("crates/nu_plugin_*").each do |plugindir|
      next unless (plugindir/"Cargo.toml").exist?

      system "cargo", "install", *std_cargo_args(path: plugindir)
    end
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu -c \'{ foo: 1, bar: homebrew_test} | get bar\'", nil)
  end
end
