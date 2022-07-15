class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/v0.10.1.tar.gz"
  sha256 "5d53808eaad2d724bdb071756217f1c53d87a918a1c46d7693154deb5dff0973"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b90545b4a188eca437feb7a5f00efb319a897f4b6cd74013587a4e281bd77799"
    sha256 cellar: :any,                 arm64_big_sur:  "99a5a255df30a4ecf415043cb1fa95442a271716d43b33b68b25a10eee800cc7"
    sha256 cellar: :any,                 monterey:       "aa3a44ca3822c0b5cd7e0d4673b92cc3eb19c9c13419bc2dfd00ac6438bf336d"
    sha256 cellar: :any,                 big_sur:        "38f066b39a89d79a93f8216670688f4b14295e383a50790f5f03fde950607ef4"
    sha256 cellar: :any,                 catalina:       "d1f2306e5ab64fa3add7c9b26f97a449840ed4292b74e5b92d094ddd6ba95f35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ae584e6b97018ea0997af1302fbbc363f93e8dedd65b9070ca15709c02f43bb"
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

        [dependencies]
        clap = "2"
      EOS

      system bin/"cargo-set-version", "set-version", "0.2.0"
      assert_match 'version = "0.2.0"', (crate/"Cargo.toml").read

      system bin/"cargo-rm", "rm", "clap"
      refute_match(/clap/, (crate/"Cargo.toml").read)
    end
  end
end
