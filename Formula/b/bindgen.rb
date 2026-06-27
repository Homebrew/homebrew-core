class Bindgen < Formula
  desc "Automatically generates Rust FFI bindings to C (and some C++) libraries"
  homepage "https://rust-lang.github.io/rust-bindgen/"
  url "https://github.com/rust-lang/rust-bindgen/archive/refs/tags/v0.72.1.tar.gz"
  sha256 "4ffb17061b2d71f19c5062d2e17e64107248f484f9775c0b7d30a16a8238dfd1"
  license "BSD-3-Clause"
  head "https://github.com/rust-lang/rust-bindgen.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2f7d3db04e1d65571db3b16e177306ac4eb49b5822285f16f3fb10efb1ef4c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b3a1d65a74fdc60b6baf24a69534ed17f9125be32c5d558259284422478d2cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84e886c463767c888ab70a4f433110146e55a3efd8e3b81bac60a49ed9bd9f31"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed1122e2b31766476afb2d1a56408b1b290ef935e87fc4b5a2a1b4110aadad01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd76fccd60a9833a65116705011cbe7357729c425e11634076c2aab36b84945e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ea06f579a2e35648dd5127263947f8d654809ed968c26db40cf8e3884e7eb11"
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
