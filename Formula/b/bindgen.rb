class Bindgen < Formula
  desc "Automatically generates Rust FFI bindings to C (and some C++) libraries"
  homepage "https://rust-lang.github.io/rust-bindgen/"
  url "https://github.com/rust-lang/rust-bindgen/archive/refs/tags/v0.70.1.tar.gz"
  sha256 "243ed50f99c00ae8c18d50429a1278b6fd37dff94df46df38f2733745362c014"
  license "BSD-3-Clause"
  head "https://github.com/rust-lang/rust-bindgen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "dbb56aa55bb1f3804891749a4d79d0cf7a896c8bfc72c35365a24fba7eebd3a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9fe50efffbbff5510d7ce03ea65aa8d082980cbd6ae1bdd5aaf8415bfa4e83a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6c1a89a88796f3c40f4df3ad756d45f49a871d28410fec99068e6df7417c967"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20c2b8c3e2f54bdc5dc9ac084f7c4cd03ea0f0d5ca5a8e3634da54805c3e013b"
    sha256 cellar: :any_skip_relocation, sonoma:         "7eb7d45f6c308e9d2766b9def96f2411379503ad1220487a5176fa816510a632"
    sha256 cellar: :any_skip_relocation, ventura:        "f5904e137a5624771d40a0a64443750515300ee3616d3fa8f928028c3531bb1b"
    sha256 cellar: :any_skip_relocation, monterey:       "9c337695d4b4e4049e1e932ae2b983917de165cbf2f145a2caadaa71918c00db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d30f81a5c96ab7c11bb42431bd5d270a1fd4dc2614823d5372e8147a378477a"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" # for libclang

  def install
    system "cargo", "install", *std_cargo_args(path: "bindgen-cli")

    generate_completions_from_executable(bin/"bindgen", "--generate-shell-completions")
  end

  test do
    (testpath/"cool.h").write <<~EOS
      typedef struct CoolStruct {
          int x;
          int y;
      } CoolStruct;

      void cool_function(int i, char c, CoolStruct* cs);
    EOS

    output = shell_output("#{bin}/bindgen cool.h")
    assert_match "pub struct CoolStruct", output

    assert_match version.to_s, shell_output("#{bin}/bindgen --version")
  end
end
