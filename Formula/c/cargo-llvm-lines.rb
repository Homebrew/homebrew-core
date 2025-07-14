class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/refs/tags/0.4.43.tar.gz"
  sha256 "58c9f6c69c9087fd06b080e15db417a51b2cce5ba95e918ba5aab54a1e05e5a4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17e02af2de28cae6ab8b5dd0774ee297b4776d687be40bac8cd35f0b1e868c54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0e208a2ecb1f3edc790957903156eab77e41c67fabfa31d3cd305117ab91e29"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df6fc4d9388eb172d3379a0f8380a9151e306ce9af2ace04a9dfca045ca281e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cbae977fce3fdc25587bf0ef474228bbb4c181aa32d1026bd90b47bfe4939ed"
    sha256 cellar: :any_skip_relocation, ventura:       "f81cf79811ebe412c116240986f2b40baba795e689806937f7c2e0b4ffa98fe0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbb1363f64e61bfc190bd1902fc56a2a62d1aa10d34494720826c0360618bf00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "163447bee1a6759aa0c7f375d939559dc7f8b19ec0cc4ee89c043b57426fa417"
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
