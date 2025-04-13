class Bindgen < Formula
  desc "Automatically generates Rust FFI bindings to C (and some C++) libraries"
  homepage "https://rust-lang.github.io/rust-bindgen/"
  url "https://github.com/rust-lang/rust-bindgen/archive/refs/tags/v0.71.1.tar.gz"
  sha256 "620d80c32b6aaf42d12d85de86fc56950c86b2a13a5b943c10c29d30c4f3efb0"
  license "BSD-3-Clause"
  head "https://github.com/rust-lang/rust-bindgen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca49bd90c74ef16524752b0f0f0ddab98724b6e5a4efff80a87306cfa1bdd435"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d0816e866afb30c80ac13d1f99009fc31407167e56ea5dbd77c16220a9be45f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a704b4131af2a7b3b89584a7999816a9d39e7fc0efc062085bca77993e9fe3a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "be5a61b23b1deaeb288a04b23e2f950bb8a52ab3c2278e5c2b9a74102ff71d2f"
    sha256 cellar: :any_skip_relocation, ventura:       "4d0759fa388a37917a70afa38c2020e6c9d3bfde4a24d446d84284efe308e7b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cea4dc5af2f263bbb02726b1111fc0275058c2e888dd2f9bc7a889daa7c8c04b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41b1a9322bcec771b42a3ebf07ee63d91fdaf66751f06deecf1e921b4f8da23f"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" # for libclang

  def install
    system "cargo", "install", *std_cargo_args(path: "bindgen-cli")

    generate_completions_from_executable(bin/"bindgen", "--generate-shell-completions")
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
