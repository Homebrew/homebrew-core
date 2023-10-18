class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https://github.com/sagiegurari/cargo-make"
  url "https://github.com/sagiegurari/cargo-make/archive/refs/tags/0.37.2.tar.gz"
  sha256 "51432d2c89ee6c17cf0b9721cd77e9f59327c29ef3e93a17f46cdfdb37567297"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a1758485199328e222d2e21bdf46ba0063e5d26bc992097cf5f4361ec9070914"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a35871a27b2186b14c548cb626963328c0e6261cba40bfd92e2db1b1502dde79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "043402b186f36c05a2a7271eaed70b28c071da699f0baab03aabca97b3717c41"
    sha256 cellar: :any_skip_relocation, sonoma:         "54e19619a462883017cef30f66e95822aa050e707198e672d65ea0c2392ca43d"
    sha256 cellar: :any_skip_relocation, ventura:        "2a4b8dff79afacd938043881bdea58dfdafb548c55fc5791e2cccb0b7ebf42c0"
    sha256 cellar: :any_skip_relocation, monterey:       "559789d572b62402d809e1288ee98bb3ffbdfb310eef16121602ad6ffaf7518c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4aad7bdc06be3d4d16c963cc865c9b70728b54fb4852d9c550f96d5249756e99"
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
