class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/refs/tags/0.4.42.tar.gz"
  sha256 "758cfc5e2b30578912e5d0e3faabf4ffe0e4ed316bb6bd464a4c81c45f5e25c9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d0066a18e73fb045e80ef304423215bfd0a029e0180ecab07289a1478f22c39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "551d3123cb0200c3cd26a2ea51c41c766d571832337fb08b7431fd383b2f776f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4e29b368f5bc237d886ec8d44a9788e6636e1d59cea25aa16fa3dad032eb926"
    sha256 cellar: :any_skip_relocation, sonoma:        "d60b6dde261ed8fc0c23e7edaa63d2ac5cb2b04227ae93be718b0b14048c5621"
    sha256 cellar: :any_skip_relocation, ventura:       "f9d6b6dfe250bd19ae2c018839f4cbccf7e7ddfda01c5fb60038b1017a31f44a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95078ff0ad5744cb5e3974e752c244961fdd3c14a1d1fbe29d655a9e4a484efc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13717c12b7d492991231ef8124dd961eaf091a5eb1faa0a8e68cbfd57766ed4e"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      output = shell_output("cargo llvm-lines 2>&1")
      assert_match "core::ops::function::FnOnce::call_once", output
    end
  end
end
