class Bindgen < Formula
  desc "Automatically generates Rust FFI bindings to C (and some C++) libraries"
  homepage "https://rust-lang.github.io/rust-bindgen/"
  url "https://github.com/rust-lang/rust-bindgen/archive/refs/tags/v0.69.1.tar.gz"
  sha256 "c10e2806786fb75f05ef32f3f03f4cb7e37bb8e06be5a4a0e95f974fdc567d87"
  license "BSD-3-Clause"
  head "https://github.com/rust-lang/rust-bindgen.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0071a1c392f24ffd8988cb5c0194df3b0fcfdd4ab371c0188c042a7018869a83"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a678cec8c4de2a48f78db5d9b4c731827f40d4b616d76275bad769a89e0be76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7eb88d5dd4ed339b04d203a95c648eedffc08e329b3a6124ee5e8e741a9f2da"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a902aeff446dbb279b0b2a2bcc66322d2704fe203adcbd7a1fa767413947058"
    sha256 cellar: :any_skip_relocation, ventura:        "c69f557babc0391127ec44ba93244d6ebfd087cc199c7017e9a418959fbb3579"
    sha256 cellar: :any_skip_relocation, monterey:       "21fc772c5856123eb5fed0ebef2538665bd87bd9e39abb05ef0e46b0f70027b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "612e83248d7b2ef89abc3e3192a2fbe4008b9f5519023f09af20a8dd97f99909"
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
