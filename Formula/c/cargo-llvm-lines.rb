class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/refs/tags/0.4.46.tar.gz"
  sha256 "048cc942bae27bc6ad9f7a9ad5931259661d6988041af94465ab13aa2d94d87d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03910aad4dd26f3c2294a5d42f0bc1f5b719913cb263feb79451d1c9aea5ebd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23990ea9a7182ae3b0e2efe36f522446518e413930474e5c9d39bba2f91ac568"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "337f1f3dff03f81e9650468ce4b6da3b8652ccf9b82b847f015b08bcd1b7d992"
    sha256 cellar: :any_skip_relocation, sonoma:        "52e8aacbb04fb81b719788a365d4565e8fdfa5fbb472b1663e3471b5565155ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea932e381510ad1f1035f299c5f75e325c743a72d628360cfc91a45e9b9a6bbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b3a1f0e63565b4740e78904abf0e99024d415fd1c2162038ac3d8b1a282613d"
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
      assert_match(/core\[\h{16}\]::ops::function::FnOnce<\(\)>>::call_once/, output)
    end
  end
end
