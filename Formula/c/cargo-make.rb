class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https://github.com/sagiegurari/cargo-make"
  url "https://github.com/sagiegurari/cargo-make/archive/refs/tags/0.37.9.tar.gz"
  sha256 "86993cb978c2c84263e66f04407363dbfa4c2ad52f1d58582f69dcf13b1f7422"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1fc07fc786fd890223f16e30d24339b60cfadf86fbddf69d7d0516bc7f11798e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "307239f908b778ca53dbb8abde3aeff2ea4a114b44982eda84f30d633b442b92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08d2f130f817198e71f957afabea3d1034d2ae2338d3975aa7a3cc0178f85145"
    sha256 cellar: :any_skip_relocation, sonoma:         "b0bdba8807578223c29bac966214a316639d9793d3fcc8fb7bf82f5099fbd12a"
    sha256 cellar: :any_skip_relocation, ventura:        "37fb02ae7bf105c482e1e52489f10a7073c1490dcbd7bcc4d37d81aabf9cc5b1"
    sha256 cellar: :any_skip_relocation, monterey:       "be94029fcba1e5ee0fe5f0116d7caab2840e319694f79d76daeae3b2a192a842"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91b55604622d0bd6e4110b4f12229b6fd748ef517d7cfccb059bb6b4cb70b76e"
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
