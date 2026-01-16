class Bindgen < Formula
  desc "Automatically generates Rust FFI bindings to C (and some C++) libraries"
  homepage "https://rust-lang.github.io/rust-bindgen/"
  url "https://github.com/rust-lang/rust-bindgen/archive/refs/tags/v0.72.1.tar.gz"
  sha256 "4ffb17061b2d71f19c5062d2e17e64107248f484f9775c0b7d30a16a8238dfd1"
  license "BSD-3-Clause"
  head "https://github.com/rust-lang/rust-bindgen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e365fd73111ab1f7631e50ef51f4123d07e83c1f841ca7eff0422f884808a40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e96f4bff4bf8646a132175f87710ffe282dadf9814a67cb0e2ab5cbfb47aaf97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68791b14f20aa5fbf605d2c762f4937c6e2389ab0659cf034699dfa5f41a2969"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b944567744c969e7238489247ecaa33f89fe66db3a1b02e58280a083688f8d83"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c7bb66b409bc5c4e9eb5f72cca1731fff75f37f7d1384ca8898d8db8cae48eb"
    sha256 cellar: :any_skip_relocation, ventura:       "792a06e919fcf82e56401303df647e59151368a8df2b633f6a042eef48f9d62a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b6fe44a6d1ee205e403de6abdfb06a0956ff3747a4201100e5c031beaa86599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a12ce571a9dcdf6ba8212d717096305d37d845c80551c3d26a0679efc76e2824"
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
