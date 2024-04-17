class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https://github.com/sagiegurari/cargo-make"
  url "https://github.com/sagiegurari/cargo-make/archive/refs/tags/0.37.11.tar.gz"
  sha256 "c4f36ed50ee2f6786a29c20567a70aedca5e0e101a7388f44de1ba5445f3ec3e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6596167363b7a2e57b615522d07d457eec2979d2194eedb21badc34afed68a34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8eafa9f1c607219d28a69c70c99c3d5518c52b772fb1fb6e2aeef99b8a1d6e2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d55ab5073b7dd682fac36796dd92d03945d58d71741ba63285c2e42544a153d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec4e46528af50822fd80fa0e93e45ddf2a9590b98ad952d6a0302f3b026e6eb6"
    sha256 cellar: :any_skip_relocation, ventura:        "a48588c91e6659225b2dfe70a1e7c64a1cb923b922bb63947360f2555f2ada30"
    sha256 cellar: :any_skip_relocation, monterey:       "b16126244290583254475527e887c66878833e93fd70b06653588c9d6ed0ff7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c41b3745cad077c525b3bc32239ee46e6a8fb4abed7c289f6c9ca0b440be8112"
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
