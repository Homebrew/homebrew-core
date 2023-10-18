class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.9.1.tar.gz"
  sha256 "08a3f129d20f477566e287df5a6f4ad6a3cda0d768d2afd768cfd8bf5887c770"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4eb087144be71ec3b9ae032a5d45cb57e0267f6293c7849fb2c4af5f1ac2f7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c34cbf3c04918d7ed5f2eb74f7312c9802d50f88d72fed9634ad77faad880959"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89fb3963f71ac1e0b8308042a8c7cbeabf46f9b44144e22b147345f57a7cc38d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31e1c3e7e1d33513a27e7f847b6470f742a197265b001867094dcbf5bd976f5e"
    sha256 cellar: :any_skip_relocation, sonoma:         "63b6a12452f68d588094cff93b118b862e9cb54245f2589d087a57261c209e63"
    sha256 cellar: :any_skip_relocation, ventura:        "3268db8ab4fa9e04140e2b7cfd23fbab4b7c996eaae1ac3ec80626183d44328a"
    sha256 cellar: :any_skip_relocation, monterey:       "da2b397a39a48c8c1f020f7bd674c29d94b18901fe505661672da1a315d9c579"
    sha256 cellar: :any_skip_relocation, big_sur:        "056a6fcfeabaafc88005d778ca5da53a2606abc2245512c05507fc2e02d2a526"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74726accb1c1ddee812cfc653a9e3c0e996ff217448d32c083cf0aed6719566d"
  end

  depends_on "rust" => :build
  uses_from_macos "bzip2"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", "--features", "tls-native", *std_cargo_args(path: "duckscript_cli")
  end

  test do
    (testpath/"hello.ds").write <<~EOS
      out = set "Hello World"
      echo The out variable holds the value: ${out}
    EOS
    output = shell_output("#{bin}/duck hello.ds")
    assert_match "The out variable holds the value: Hello World", output
  end
end
