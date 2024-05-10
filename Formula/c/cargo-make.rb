class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https://github.com/sagiegurari/cargo-make"
  url "https://github.com/sagiegurari/cargo-make/archive/refs/tags/0.37.12.tar.gz"
  sha256 "5ae62755b738fbab8e1247973d0ae3499fc05b8087d8ba14f9a3ac52c5ebbf1d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "75ccad7c2cf3f1e184966ea6754097d52396b52b7200ea4e13a48fa6349a34ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ac326de38d157944564ac39dea2467a28681fd8aa0c658bb035a25ae09de025"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19f88c224d28e619d70c5cdc70b5ae9a46d35ddc538709ea6b89922952cbd3aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7484a4a9f710b273f5a1132f70dd5ec3eb388d94d0029994aad0a7dc5ba7896"
    sha256 cellar: :any_skip_relocation, ventura:        "2c0d9aa2e9c91ee0f3b1e7e6a1737c51e5a3033fc1e231118f46084731a7d3ab"
    sha256 cellar: :any_skip_relocation, monterey:       "7e12ece46b6e2c704e559bda37664a529de6b06f3b003ca3df4cf0e3a33b38cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b1871275226bbb918c2f9f1a42feb572512c0e5386ccf0580a31b6ae7b59b83"
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

    text = "it's working!"
    (testpath/"Makefile.toml").write <<~EOF
      [tasks.is_working]
      command = "echo"
      args = ["#{text}"]
    EOF

    assert_match text, shell_output("cargo make is_working")
    assert_match text, shell_output("#{bin}/cargo-make make is_working")
    assert_match text, shell_output("#{bin}/makers is_working")
  end
end
