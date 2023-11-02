class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https://github.com/sagiegurari/cargo-make"
  url "https://github.com/sagiegurari/cargo-make/archive/refs/tags/0.37.4.tar.gz"
  sha256 "720f29c09a3b02b45390583418ba8df5a70cc3492da88a914355a1da5fcbca81"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6bcd88a55638181905f56cf4ce1bbc11a843a86ec69f00d853a01db71e01102d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01db291c1e91e900702b3a7a12038fc99c6ab0b48d71fd385f6b493f80cdded0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "445cb21e664f2e9c42117f271bb9de17697f3b322e5fdb154e20b6c57204ac65"
    sha256 cellar: :any_skip_relocation, sonoma:         "ffdc316eca072488518139bba514a3b2c1fca2c8fc39d09cd0ec05c1a9fc776b"
    sha256 cellar: :any_skip_relocation, ventura:        "4032be4c2788740e26075c1be3e3425a6bd87a888b0b82d0c934ee63a9e4c0a9"
    sha256 cellar: :any_skip_relocation, monterey:       "5d900d69fda1f449192e4c52554d6520bf04e3141534c2cd80270329b32859ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "260359d0338af7b9efb1be7987e69ee7de311231303247ac7376a8ea3730d55a"
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
