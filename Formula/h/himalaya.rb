class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://pimalaya.org"
  url "https://github.com/pimalaya/himalaya/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "e6843e062be203d6c97b392f4f4f58844c3ae16f42849704727029e882274e0a"
  license "MIT"

  bottle do
    manifest_sha256 "08759b4605421953ec712924c9a2c2e6eba1f344352fc02bb97a7d784083d3ab"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6a7d5977c465afc36e64023975ca64038b9f4f33904e7e579ee745cf520c87c7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6c8f5a153ac8b7a7342a2c095407257a7c7d11f9342725c19f14ecb43eb666c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a91d1ab63881338d6c331c0928eb2ebf338ce2a0d85bb9e58685791d5972c38e"
    sha256 cellar: :any,                 arm64_linux:       "0896700e40576addf2949189c2a60f5787dcbe2339f384f29902287e61e4e411"
    sha256 cellar: :any,                 x86_64_linux:      "f04b6202f73092f3dc3c1d642341a2956bfad764faa987b0d687ae9fa7509364"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    system bin/"himalaya", "manual", "--dir", buildpath
    man1.install Dir["*.1"]
    generate_completions_from_executable(bin/"himalaya", "completion")
  end

  test do
    (testpath/"config.toml").write <<~TOML
      [accounts.personal]
      default = true
      email = "alice@example.org"
      maildir.root = "#{testpath}/Mail"
    TOML

    assert_match "personal", shell_output("#{bin}/himalaya --config config.toml account list")
  end
end
