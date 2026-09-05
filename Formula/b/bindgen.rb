class Bindgen < Formula
  desc "Automatically generates Rust FFI bindings to C (and some C++) libraries"
  homepage "https://rust-lang.github.io/rust-bindgen/"
  url "https://github.com/rust-lang/rust-bindgen/archive/refs/tags/v0.73.1.tar.gz"
  sha256 "11d72970909c7b333eb6685054e7bbd36fd8892eab40ce3a93da06f066ed983d"
  license "BSD-3-Clause"
  head "https://github.com/rust-lang/rust-bindgen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39958c407fe0675c2b22765413e92fcfa1cca0c7100bebdd9e243fa82e02cabd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65b431508800d1fc607564ae9c6c1ea4b9fcf9f12bf34b748af4119584f476f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17cc3d01c2358bcabb094c4ebdc45b97978dc6cf52163065c0c07a6dc61e4322"
    sha256 cellar: :any,                 arm64_linux:   "59f386960ae468167d2b9be1f83798b5da5953030a2c9a1c501011bb35a37e69"
    sha256 cellar: :any,                 x86_64_linux:  "a0a6329fa82b4c03882bfcd3639b3a42a9ceb7cb0e73774d8002a411d794fa7e"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" # for libclang

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
