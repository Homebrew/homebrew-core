class Pgrx < Formula
  desc "Build Postgres Extensions with Rust"
  homepage "https://github.com/pgcentralfoundation/pgrx"
  url "https://github.com/pgcentralfoundation/pgrx/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "8638d911003b93e8a73ad86e3cfa807165d2d3e69fce45dff98b19838ca66d13"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18ec52d8f23536e3d83cae766791ce71909ea1ecfe8d8825ca08c28900e6e360"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0635a05b7737daf0b4920af5d82304362ac2bd68af62bbeef539b0701ff445fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a81c4f856715e16bac6cc47e06db980bff34ea6a7e0305ee62922381e2c1b88"
    sha256 cellar: :any_skip_relocation, sonoma:        "f51e9c9b42b10de08a5d03be749a015981b0e71863de04c1924868d763743628"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6f41bedbb746bf6b0cb10f431ea03da30c7f2c174685871ff9a48f18e30190a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6c3c8f45df8886bdf8f9a9a5065c66217b06b22af1722ef2fb233f44f5c5bb0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-pgrx")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    system "cargo", "pgrx", "new", "my_extension"
    assert_path_exists testpath/"my_extension/my_extension.control"
  end
end
