class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https://github.com/sagiegurari/cargo-make"
  url "https://github.com/sagiegurari/cargo-make/archive/refs/tags/0.37.1.tar.gz"
  sha256 "88e5cd16b4ad2238f8b113e97d278296dfab72037470943c709f3b1ab099cb1e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b32fb7d0d35c503cc2a8b8bb9a3f01ccc0dbb0597011847e2d494462311c1792"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f267e0610e82a03d3864a3368731912156f10ede954547743c1cf2cf14bc45c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf88c0c93a944786dbea0cb79ed2e261e04df5d813d2aa24bc12f59d71d1a660"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd1b3908da5dfd7f491fc4876431e14d5fc8bed807b170b2442ecade31b659c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "95ef1326c3d292327e6690ba4e8719e0b0cd240dfa5a0f11afa964be626872a8"
    sha256 cellar: :any_skip_relocation, ventura:        "9ae18b3cd990ec9e1ebe87a8a768761ca7614429456dafc8bdf1aeecd3d151b3"
    sha256 cellar: :any_skip_relocation, monterey:       "59340f2fec17b59b5cb2209d16458869f51bcc726984c0061145249237aaf795"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a0fac5f7e2a0ff6bf4373ce9a7941d4befa9824ec29eadea3a772e21111bb1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06d1a84cf028b2870db45eb0175603e1d4f16b25858cffb5ddd18d925c5b8fc2"
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
