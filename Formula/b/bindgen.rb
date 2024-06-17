class Bindgen < Formula
  desc "Automatically generates Rust FFI bindings to C (and some C++) libraries"
  homepage "https://rust-lang.github.io/rust-bindgen/"
  url "https://github.com/rust-lang/rust-bindgen/archive/refs/tags/v0.69.4.tar.gz"
  sha256 "c02ce18b95c4e5021b95b8b461e5dbe6178edffc52a5f555cbca35b910559b5e"
  license "BSD-3-Clause"
  head "https://github.com/rust-lang/rust-bindgen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c4fca8f842d290edf0e9156dd6d24d00440cb5a3edd5d362e52a21089cdccd4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50e6c6a95afe1212fa5222f1e885d83945067e8b1265e645400b47b47ea5009a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24b41f3c5b5fe92950310d8649356a1fdb1848a571c93d089ca1394131e64d35"
    sha256 cellar: :any_skip_relocation, sonoma:         "98c8486f92706d18c36733fce0d81a15b98224cad7b8bb10cd827b82ead5ee81"
    sha256 cellar: :any_skip_relocation, ventura:        "9cba60c9e6083651b428babc0cdf7d6ea41dc67b2c4f071c1b4c271be48e30b4"
    sha256 cellar: :any_skip_relocation, monterey:       "57e7025e7a4fbf359b042ef7589789e1f640c5012f3ed25a8b9900052e0be9f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e6d4d9bcec59656e9b8a8d75e07e67b8eeb123079aa4bb513ceccb4c1efcb3d"
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
