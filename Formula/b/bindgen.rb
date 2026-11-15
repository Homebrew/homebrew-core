class Bindgen < Formula
  desc "Automatically generates Rust FFI bindings to C (and some C++) libraries"
  homepage "https://rust-lang.github.io/rust-bindgen/"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 1
  head "https://github.com/rust-lang/rust-bindgen.git", branch: "main"

  stable do
    url "https://github.com/rust-lang/rust-bindgen/archive/refs/tags/v0.73.2.tar.gz"
    sha256 "5fc3277dd334e4bbbd7bdb8cad5d4fb87a667b2e95a2bae350a8d5424c280629"

    # Backport fix for LLVM 23
    patch do
      url "https://github.com/rust-lang/rust-bindgen/commit/0961e4829390e94c912291dff07c76d5357febb4.patch?full_index=1"
      sha256 "61bb9581154cf9b6f02e98f8ab036e0c0930fa1c04c995c2af28a77f81c6facb"
      type :backport
      resolves "https://github.com/rust-lang/rust-bindgen/pull/3536"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "233f5ef309bcb2552916b19ee35a58303242658ead042361f9dcf7d237d17e73"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a2e36f26086055c9d97dbd9a00f016f23722a1e4e35687fbde5861e385fc01fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4727fb2c47f3db6e467d9bde023287bba803eaee791bec099d58394cf57e27f5"
    sha256 cellar: :any,                 arm64_linux:       "07f6b9b07bb0f20fb22a5a01c6fce0af621cd3553790ace3c15e79c152c2e6b0"
    sha256 cellar: :any,                 x86_64_linux:      "248dc6ae5dc944decb8597d3bc0ed4d3cafaa9ad1988e48840e949b86942f878"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" # for libclang

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "bindgen-cli")

    generate_completions_from_executable(bin/"bindgen", "--generate-shell-completions",
                                                        shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    (testpath/"cool.h").write <<~C
      typedef struct CoolStruct {
          int x;
          int y;
      } CoolStruct;

      void cool_function(int i, char c, CoolStruct* cs);
    C

    output = shell_output("#{bin}/bindgen cool.h")
    assert_match "pub struct CoolStruct", output

    assert_match version.to_s, shell_output("#{bin}/bindgen --version")
  end
end
