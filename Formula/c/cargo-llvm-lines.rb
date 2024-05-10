class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/refs/tags/0.4.38.tar.gz"
  sha256 "f8fccbf610c24151314b0e94650b2169108a587c9e2207576cf460e4a145da9d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f11cef339c84be3802c8c9ede20ddb476c11927eea9023fe96a5d06900071a3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "873e5d23f0748370e0f828ab0e3e5c6b031c3c5669e6a2b6f81752356a1d7a30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "542657669a2f23966c03a11044f4942cf585561d9539cf7d3df45a1f51ffbf72"
    sha256 cellar: :any_skip_relocation, sonoma:         "d22c06144c159d589c0ef1541b15b6a62dba8baef192d877912433419e4e3ed3"
    sha256 cellar: :any_skip_relocation, ventura:        "1339dcc02919c6301f8f74dbe89d04ed8c3282d0617953fd44da2a199e87c2be"
    sha256 cellar: :any_skip_relocation, monterey:       "741e111d05f696d3cb52140e7ce7f3932bbeeeaae6dfe0efc52afca22ed57eb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80ae7946a6276b2421fe0ef5a0336ab398a3889a0f24bda84ff1270ad2e70753"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin/"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      output = shell_output("cargo llvm-lines 2>&1")
      assert_match "core::ops::function::FnOnce::call_once", output
    end
  end
end
