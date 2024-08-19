class Bindgen < Formula
  desc "Automatically generates Rust FFI bindings to C (and some C++) libraries"
  homepage "https://rust-lang.github.io/rust-bindgen/"
  url "https://github.com/rust-lang/rust-bindgen/archive/refs/tags/v0.70.0.tar.gz"
  sha256 "9afd95f52c55147c4e01976b16f8587526f0239306a5a4610234953ab2ee7268"
  license "BSD-3-Clause"
  head "https://github.com/rust-lang/rust-bindgen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4808a8b13a55a8e359fe237a47947fc9612800ffc8a53d86bd9c0af699230c7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24cfc9b05d8d592299ec54c2171a45b3707edc18451084c8cfd038029eb66abc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4263516925a6e549a8329cce15662a6866aef1ff4f692046fd991b463b3b9d51"
    sha256 cellar: :any_skip_relocation, sonoma:         "e25faf09fe37c5dd43f6be7eee137a59bd1bc7a68953aea866a9ab482cae2c30"
    sha256 cellar: :any_skip_relocation, ventura:        "fb96463cebd1e4b9660fc5b4ecc09925c80ebe9cc7e1919086eef5a58a8b583f"
    sha256 cellar: :any_skip_relocation, monterey:       "e853ff11326a4daf3f0b5453a96ac523e591eb0073a25ce274c0d608b56a30a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "681d8b12c9be9c08994f1b794e2c6a969bdc42ac2bd7011d4e89f9f22fdc8436"
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
