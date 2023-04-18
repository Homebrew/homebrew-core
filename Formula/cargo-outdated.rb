class CargoOutdated < Formula
  desc "Cargo subcommand for displaying when Rust dependencies are out of date"
  homepage "https://github.com/kbknapp/cargo-outdated"
  url "https://github.com/kbknapp/cargo-outdated/archive/v0.11.2.tar.gz"
  sha256 "7e82d1507594d86cb1c2007d58e329a9780a22bdb0f38d5e71d2692a7f1727d9"
  license "MIT"
  head "https://github.com/kbknapp/cargo-outdated.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d8cd073522412b7093a64aef27d8dbedca7af67025655fc6c13122e2efe89692"
    sha256 cellar: :any,                 arm64_monterey: "35c884f6280d69902679c19070e36adba44cb71c0925669be9f1ad7259dc0a9c"
    sha256 cellar: :any,                 arm64_big_sur:  "98ca6511edf4be09b0a6a9784445448798914fd45b5dd3e3583f95a87e61d01a"
    sha256 cellar: :any,                 ventura:        "68c1827cdf769517cf6d5256bf7ee8bf77a64678a31d337d0810223562a1dd5c"
    sha256 cellar: :any,                 monterey:       "572b7ce4f05e9d30a86716bd8cae8ed2e97698c0930d9abf3f577ba66b646b0f"
    sha256 cellar: :any,                 big_sur:        "79420cde5823ccd0714e309c9aa3561f028daa4e7ab87a0fa5df48df57aee0f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30bc7667a6e1bf3e04835e0db2426b25d2bbbc0290140d75ec7200b85f3e002e"
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
