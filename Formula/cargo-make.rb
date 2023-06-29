class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https://github.com/sagiegurari/cargo-make"
  url "https://github.com/sagiegurari/cargo-make/archive/refs/tags/0.36.11.tar.gz"
  sha256 "d49a8b31b28dbdaddab2f93ed29c2db6c31259f501b49e15e6e779fe53807f63"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6774fc4f424bbd8b7e0919bd4c64b4f94169d5dc4e2221b1a33449550f93e45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73c856a040469f3a5e42854f772013bbfdd3c9878581a110925ef8c656a714e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1b43b2532f679b5da8cedba41d3d4e929160865bdb932c3bace1d0423e3d586"
    sha256 cellar: :any_skip_relocation, ventura:        "52e1a8845eee0f5db37cfc851928df0bccf1fed5825021b1af9ef9e15669447a"
    sha256 cellar: :any_skip_relocation, monterey:       "35ef04ce5b6dad8630f176849ab8bf62867e0f538bbb5118f88edf79637945ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "4531e5fbb555cbab6cd69c92d30162143e1390e9c9f6d18c1da898db9630dedd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d018c0986764f14d3690a3e111659460f61a135b10f9079aced29e8ae7cd298"
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
    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "rustup", "default", "beta"

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
