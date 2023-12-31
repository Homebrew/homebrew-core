class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https://github.com/sagiegurari/cargo-make"
  url "https://github.com/sagiegurari/cargo-make/archive/refs/tags/0.37.5.tar.gz"
  sha256 "d235f81d06c7f00fe8cd3359e967c7c3a5e81b26e91adcb00b951e6927cc91df"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c2587e822fc738b7eabcb1f40d755c21e32c69c8504da9001b1921e77fe3f15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3ef657f4c470d336bd674dce9ce80d95182ce8d981c36c1c49b0e226249d9bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d88470578bb24570eb13d2ef9df8b20ffac4f3a247595e2e65784594e06a8fd3"
    sha256 cellar: :any_skip_relocation, sonoma:         "3baf235f44d1f5295ac983303033176b9e88436a2ebd9ada727b72c2d08c9a66"
    sha256 cellar: :any_skip_relocation, ventura:        "329016a759211fe7a87af694c26aa2f401825e6adb6395825378f934cab7c3e0"
    sha256 cellar: :any_skip_relocation, monterey:       "9a157145eb2272ca45615e978a1d5256c8747953c36a6926d5dfde42b5e8f053"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a428c60f14b78166281cbc7c71270e2edc9e1ca53e70312de5b8b5b4486fcc0"
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
